# This script builds a simple regression model to predict departures from the expected price
# (predicted by market research). It generates then a few plots and reports on the distribution
# of the residuals for the most popular classes of products and services

library(data.table)
path = "~/Collusion/COMPRASNET/R_pregoes"
setwd(path)
dir.create("figures/var_padmat")

F_ITEM_COMPRA  <- readRDS("F_ITEM_COMPRA_filtered_no_outliers.rds")
F_ITEM_COMPRA  <- F_ITEM_COMPRA[ANO < 2015]  

PROD_FREQ  <- sort(table(F_ITEM_COMPRA$ID_ITCP_PADRAO_DESC_MAT))

summaries = list()
variances_ano = list()
variances_uf_ano = list()
pregoes = list()


# Run basic linear model and record residuals
ORG_REG  <- lm(log(VL_PRECO_UNIT_HOMOLOG)~log(VL_ITCP_PRECO_UNIT_ESTIM)+PRESENCIAL+SRP+ME_EX+
                 QT_FORNEC_PARTICIP_ITEM+I(QT_FORNEC_PARTICIP_ITEM^2)+log(QT_ITCP_SOLICITADA)+
                 factor(DS_LCAL_UF_UNIDADE)+factor(ANO),data=F_ITEM_COMPRA)
F_ITEM_COMPRA[,lm_resid := ORG_REG$residuals]

# Record residual variance and frequency for each category, and select the top 100
prod_var <- F_ITEM_COMPRA[,.(freq = .N, variance = var(lm_resid), variance_2=0),
                   by = .(ID_ITCP_PADRAO_DESC_MAT,DS_ITCP_PADRAO_DESC_MAT)]
setorder(prod_var,-freq)
prod_var  <- prod_var[1:100]

for (i in 1:100) {
  print(i)
  most_frequent  <- names(tail(PROD_FREQ,n=i))[1] # Get the  
  most_freq_table  <- F_ITEM_COMPRA[as.integer(ID_ITCP_PADRAO_DESC_MAT) == as.integer(most_frequent)]
  most_freq_table <- droplevels(most_freq_table)
    
  if (as.integer(most_frequent) == -9) { next } # Ignore if it's the undefined group
    
  # If there are not too many subcategories, than include dummies for them
  if (length(unique(most_freq_table$ID_ITCP_TP_COD_MAT_SERV)) > 1 &&
      length(unique(most_freq_table$ID_ITCP_TP_COD_MAT_SERV)) < 100) {
    NEW_REG  <- lm(log(VL_PRECO_UNIT_HOMOLOG)~log(VL_ITCP_PRECO_UNIT_ESTIM)+PRESENCIAL+SRP+ME_EX+
               QT_FORNEC_PARTICIP_ITEM+I(QT_FORNEC_PARTICIP_ITEM^2)+log(QT_ITCP_SOLICITADA)+
               factor(DS_LCAL_UF_UNIDADE)+factor(ANO)+factor(ID_ITCP_TP_COD_MAT_SERV),
             data=most_freq_table)
  } else {
    NEW_REG  <- lm(log(VL_PRECO_UNIT_HOMOLOG)~log(VL_ITCP_PRECO_UNIT_ESTIM)+PRESENCIAL+SRP+ME_EX+
               QT_FORNEC_PARTICIP_ITEM+I(QT_FORNEC_PARTICIP_ITEM^2)+log(QT_ITCP_SOLICITADA)+
               factor(DS_LCAL_UF_UNIDADE)+factor(ANO),data=most_freq_table)
  }
    
  # Record the new regression residuals and variances
  most_freq_table[,resid := resid(A)]
  prod_var[i,variance_2 := var(resid(A))]
  table_uf_ano <- most_freq_table[,.(ANO, DS_LCAL_UF_UNIDADE, variance = var(resid)),
                      by=.(ANO,DS_LCAL_UF_UNIDADE)]
  table_ano  <- most_freq_table[,.(variance = var(resid)),by=.(DS_LCAL_UF_UNIDADE)]
  
  
  # Plot  
  setorder(table_uf_ano,variance)
  png(paste0("figures/var_padmat/test_var_PADMAT_ANO_",i,".png"))
  plot_title  <- paste(strwrap(F_ITEM_COMPRA[ID_ITCP_PADRAO_DESC_MAT == most_frequent,
                                             DS_ITCP_PADRAO_DESC_MAT][1],width=50),collapse="\n")
  plot(B$DS_LCAL_UF_UNIDADE,table_uf_ano$variance,main = plot_title,las=2,cex.axis=0.7)
  dev.off()

  png(paste0("figures/var_padmat/no_outline_test_var_PADMAT_ANO_",i,".png"))
  plot_title  <- paste(strwrap(F_ITEM_COMPRA[ID_ITCP_PADRAO_DESC_MAT == most_frequent,
                                             DS_ITCP_PADRAO_DESC_MAT][1],width=50),collapse="\n")
  plot(B$DS_LCAL_UF_UNIDADE,table_uf_ano$variance,main = plot_title,las=2,cex.axis=0.7, outline = FALSE)
  dev.off()

  png(paste0("figures/var_padmat/test_var_PADMAT_UF_",i,".png"))
  plot(C$DS_LCAL_UF_UNIDADE,table_ano$variance,main = plot_title,las=2,cex.axis=0.7)
  dev.off()
    
  # Save results and data for replication
  summaries[[i]] <- summary(NEW_REG)
  variances_uf_ano[[i]]  <- table_uf_ano
  variances_ano[[i]]  <- table_ano
  pregoes[[i]] <- most_freq_table[,.(ID_ITCP_ITEM_COMPRA,ID_ITCP_TP_COD_MAT_SERV,
                                     DS_ITCP_PADRAO_DESC_MAT,DS_LCAL_UF_UNIDADE,
                                     DS_LCAL_REGIAO_UNIDADE,DT_REFERENCIA_COMPRA,ANO,resid)]

}

setorder(prod_var,variance)
# save data for further analysis
save(list = c("summaries", ls(pattern="var*"), "pregoes", "prod_var"), file = "test_var_padmat.RData")
# write table with variance results
write.table(prod_var, "prod_var_padmat.txt", sep="\t")