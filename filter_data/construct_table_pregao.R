# This script joins all relevant databases in order to construct a table with data for the tests
# and run a few summaries.
# If save_table is true, then it saves the filtered database with and without outliers
# If plot_boxplot is true then it plots the distribution of the price ratio (price/expected price)

library(data.table)
path = "~/Collusion/COMPRASNET/R_pregoes/"
setwd(path)

save_table = FALSE
plot_boxplot = FALSE
print_tex_summary = TRUE

F_ITEM_COMPRA  <- readRDS("F_ITEM_COMPRA.rds")
D_CMPR_COMPRA  <- readRDS("D_CMPR_COMPRA.rds")
D_ITCP_ITEM_COMPRA  <-  readRDS("D_ITCP_ITEM_COMPRA.rds")
D_ITCP_MATERIAL_SERVICO  <-  readRDS("D_ITCP_MATERIAL_SERVICO.rds")
D_UNDD_UNIDADE  <- readRDS("D_UNDD_UNIDADE.rds")

# Adding purchase information

setkey(F_ITEM_COMPRA,ID_CMPR_COMPRA)
setkey(D_CMPR_COMPRA,ID_CMPR_COMPRA)
F_ITEM_COMPRA[D_CMPR_COMPRA, `:=`(PRESENCIAL = (DS_CMPR_TP_PREGAO == "Presencial"),
                                  SRP = (DS_CMPR_FORMA_COMPRA == "SISRP"), 
                                  DT_REFERENCIA_COMPRA = i.DT_REFERENCIA_COMPRA)]
F_ITEM_COMPRA[, ANO := year(DT_REFERENCIA_COMPRA)]
F_ITEM_COMPRA[, ME_EX := (DS_ITCP_TP_BENEF_ME_EPP == "TP-1")]

# Filtering out group purchases
ITEMS_WITHOUT_GROUP  <- D_ITCP_ITEM_COMPRA[ID_ITCP_IN_COMPRA_GRUPO>0,ID_ITCP_ITEM_COMPRA]
F_ITEM_COMPRA <- F_ITEM_COMPRA[!(ID_ITCP_ITEM_COMPRA %in% ITEMS_WITHOUT_GROUP)]

# Merging with product/service information
setkey(F_ITEM_COMPRA,ID_ITCP_TP_COD_MAT_SERV)
setkey(D_ITCP_MATERIAL_SERVICO,ID_ITCP_TP_COD_MAT_SERV)
F_ITEM_COMPRA  <- merge(F_ITEM_COMPRA,D_ITCP_MATERIAL_SERVICO)

# Getting purchase unit information

setkey(F_ITEM_COMPRA,ID_CMPR_COMPRA)
setkey(D_CMPR_COMPRA,ID_UNDD_RESP_COMPRA)
setkey(D_UNDD_UNIDADE,ID_UNDD_UNIDADE)
RF_UNDD  <- D_UNDD_UNIDADE[D_CMPR_COMPRA,.(ID_CMPR_COMPRA,
                                           ID_UNDD_RESP_COMPRA,DS_LCAL_UF_UNIDADE,
                                           DS_LCAL_REGIAO_UNIDADE)]
setkey(RF_UNDD,ID_CMPR_COMPRA)
F_ITEM_COMPRA  <- merge(F_ITEM_COMPRA,RF_UNDD)

# Deleting items with no estimated price or no final price, and extreme cases
# Only one auction from 2003 has reference price before 2004

F_ITEM_COMPRA  <- F_ITEM_COMPRA[VL_PRECO_UNIT_HOMOLOG > 0 & VL_ITCP_PRECO_UNIT_ESTIM > 0 &
                                VL_PRECO_TOTAL_HOMOLOG > 0 & VL_ITCP_PRECO_GLOBAL_ESTIM &
                                QT_ITCP_SOLICITADA > 0 & ANO > 2003]

F_ITEM_COMPRA[,R_PRECO:=VL_PRECO_UNIT_HOMOLOG/VL_ITCP_PRECO_UNIT_ESTIM]

# Removing extreme cases where the price ratio is too high or too low (usually as result of
# the wrong quantities being reported)
F_ITEM_COMPRA  <- F_ITEM_COMPRA[R_PRECO>0.01 & R_PRECO<100]


# Saving filtered F_ITEM_COMPRA
if (save_table) { saveRDS(F_ITEM_COMPRA,"F_ITEM_COMPRA_filtered.rds") }

# Removing outliers from the sample for each class of product
F_ITEM_COMPRA[, OUT_LOW := quantile(R_PRECO,.25) - 1.5*IQR(R_PRECO),
              by = ID_ITCP_TP_COD_MAT_SERV]
F_ITEM_COMPRA[, OUT_HIGH := quantile(R_PRECO,.75) + 1.5*IQR(R_PRECO), 
              by = ID_ITCP_TP_COD_MAT_SERV]
F_ITEM_COMPRA  <- F_ITEM_COMPRA[(R_PRECO >= OUT_LOW & R_PRECO <= OUT_HIGH)]

if (save_table) { saveRDS(F_ITEM_COMPRA,"F_ITEM_COMPRA_filtered_no_outliers.rds") }

if (plot_boxplot) {
    PROD_FREQ  <- sort(table(F_ITEM_COMPRA$ID_ITCP_TP_COD_MAT_SERV))
    for (i in 0:100) {
        if (i == 0) {
            most_frequent  <-  0
            most_freq_table  <- F_ITEM_COMPRA
        } else {  
            most_frequent  <- names(tail(PROD_FREQ,n=i))[1]
            most_freq_table  <- F_ITEM_COMPRA[
              ID_ITCP_TP_COD_MAT_SERV == as.integer(most_frequent)]
        }
        print(summary(most_freq_table$R_PRECO))
        print(table(most_freq_table$R_PRECO>1))
        png(paste0("teste",i,".png"))
        plot_title  <- paste(strwrap(
          D_ITCP_MATERIAL_SERVICO[ID_ITCP_TP_COD_MAT_SERV == most_frequent,
                                  DS_ITCP_MATERIAL_SERVICO],width=50),collapse="\n")
        boxplot(R_PRECO~ANO,main=plot_title,outline = FALSE,data=most_freq_table)
        dev.off()
    }
}

model_A <- log(R_PRECO) ~ log(VL_ITCP_PRECO_GLOBAL_ESTIM) +
  PRESENCIAL + SRP + ME_EX + QT_FORNEC_PARTICIP_ITEM + I(QT_FORNEC_PARTICIP_ITEM^2) +
  log(QT_ITCP_SOLICITADA) + factor(DS_LCAL_UF_UNIDADE) + factor(ANO)

A  <- lm(model_A,data=F_ITEM_COMPRA)

summary(A)

model_B <- log(VL_PRECO_UNIT_HOMOLOG) ~ log(VL_ITCP_PRECO_UNIT_ESTIM) +
  PRESENCIAL + SRP + ME_EX + QT_FORNEC_PARTICIP_ITEM + I(QT_FORNEC_PARTICIP_ITEM^2) +
  log(QT_ITCP_SOLICITADA) + factor(DS_LCAL_UF_UNIDADE) + factor(ANO)

B  <-  lm(model_B, data=F_ITEM_COMPRA)

summary(B)

# Summary Statistics

summary_table  <- F_ITEM_COMPRA[ANO<2015,
                                .(LB = log(VL_PRECO_TOTAL_HOMOLOG),
                                  LR = log(VL_ITCP_PRECO_GLOBAL_ESTIM),
                                  LBID = VL_PRECO_UNIT_HOMOLOG/VL_ITCP_PRECO_UNIT_ESTIM,
                                  LQT = log(QT_ITCP_SOLICITADA), QT_FORNEC_PARTICIP_ITEM,
                                  QT_ITCP_LANCES_ITEM, PRESENCIAL, ME_EX, SRP,
                                  N = (DS_LCAL_REGIAO_UNIDADE == "N "),
                                  NE = (DS_LCAL_REGIAO_UNIDADE == "NE"),
                                  CO = (DS_LCAL_REGIAO_UNIDADE == "CO"),
                                  SE = (DS_LCAL_REGIAO_UNIDADE == "SE"),
                                  S = (DS_LCAL_REGIAO_UNIDADE == "S "))]

if (print_tex_summary) {
  library(stargazer)
  sink("table_summary.txt")
  stargazer(summary_table, summary.stat = c("mean","sd","p25","median","p75"),
            covariate.labels = c("Log. Winning Bid (Total)",
                                 "Log. Reference Price (Total)",
                                 "Ratio Winning Bid/Reference Price",
                                 "Log. Quantity", "Number of Bidders",
                                 "Number of Bids", "Offline",
                                 "Small Companies Exclusivity",
                                 "Price Registration", "North",
                                 "Northeast","Central-West","Southeast","South"),nobs = TRUE)
  sink()
}

# Filtering out processes from 2015 and later
F_ITEM_COMPRA <- F_ITEM_COMPRA[ANO<2015]

# Number of sales
nrow(F_ITEM_COMPRA)

#Number of purchases with more than 1000 lots 
table(F_ITEM_COMPRA$lots > 1000)

#Highest number of quantity of goods
tail(sort(F_ITEM_COMPRA$QT_ITCP_SOLICITADA))

#Proportion of cases where the price is higher than the "expected" price
mean(F_ITEM_COMPRA$R_PRECO > 1, na.rm=TRUE)
