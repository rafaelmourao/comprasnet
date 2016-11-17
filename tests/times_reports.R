# This script reports the regression results for different models to explain
# the presence and number of participants left at the end of the auction
# The models here reported are estimated and saved in the script times_analysis.R

library(data.table)
library(stargazer)
library(ordinal)

path = "~/Collusion/COMPRASNET/R_pregoes"
setwd(path)

F_ITEM_COMPRA  <- readRDS("F_ITEM_COMPRA_filtered_times.rds")
F_ITEM_COMPRA <- F_ITEM_COMPRA[ANO > 2005 & ANO < 2015 &
                               DT_ABERTURA_ITEM == DT_ENCERRAMENTO_ITEM &
                               DURATION > 10 &
                               !ULT_LANCE_NO_TIME &
                               !FECHAMENTO_WRONG_TIME &
                               !ABERTURA_WRONG_TIME &
                               QT_FORNEC_PARTICIP_ITEM > 1]

F_ITEM_COMPRA[,`:=`(ANY_ULT_LANCE_0 = ( ULT_LANCE_0 > 0 ),
                    ANY_ULT_LANCE_1 = ( ULT_LANCE_1 > 0 ),
                    ANY_ULT_LANCE_5 = ( ULT_LANCE_5 > 0 ))]

sink("tables_lm.txt")
stargazer(F_ITEM_COMPRA[,.(DURATION,ULT_LANCE_0,ANY_ULT_LANCE_0,ULT_LANCE_1,
                           ANY_ULT_LANCE_1,ULT_LANCE_5,ANY_ULT_LANCE_5,
                           QT_FORNEC_PARTICIP_ITEM,QT_ITCP_LANCES_ITEM)], 
          summary.stat = c("mean","sd","min","p25","median","p75","max"), 
          covariate.labels = c("Duration","Number of Bidders at t",
                               "Bidder presence at t","Number of Bidders at t-1", 
                               "Bidder presence at t-1","Number of Bidders at t-5", 
                               "Bidder presence at t-5", "Number of Bidders", 
                               "Number of Bids"))

load("time_lm.Rdata")
lms  <- stargazer(A_0,A_1,A_5, font.size = "tiny", no.space = TRUE,
                  dep.var.labels = c("Bidders at t","Bidders at t-1", "Bidders at t-5"),
                  covariate.labels = c("Log. Reserve Price",
                      "Price Registration",
                      "Small Companies Exclusivity",
                      "Number of Bidders",
                      "Log. Quantity",
                      "Number of Bids",
                      "Duration", "2007",
                      "2008", "2009", "2010",
                      "2011", "2012", "2013",
                      "2014"))
lms
sink()

summary(A_0)
summary(A_1)

PROD_FREQ  <- sort(table(F_ITEM_COMPRA$ID_ITCP_TP_COD_MAT_SERV))
F_ITEM_COMPRA[,lm_resid_0 := A_0$residuals]
A  <- F_ITEM_COMPRA[,.(freq = .N, meanresid = mean(lm_resid_0)),by = ID_ITCP_TP_COD_MAT_SERV]

setorder(A,-freq)
A  <- A[1:100]
setorder(A,meanresid)

B <- F_ITEM_COMPRA[,.(mean_part_0 = mean(ULT_LANCE_0/QT_FORNEC_PARTICIP_ITEM),
                      mean_part_1 = mean(ULT_LANCE_1/QT_FORNEC_PARTICIP_ITEM),
                      mean_part_5 = mean(ULT_LANCE_5/QT_FORNEC_PARTICIP_ITEM)), by = ANO]
setorder(B,ANO)

C <- F_ITEM_COMPRA[,.(mean_part_0 = mean(ANY_ULT_LANCE_0),
                      mean_part_1 = mean(ANY_ULT_LANCE_1),
                      mean_part_5 = mean(ANY_ULT_LANCE_5)), by = ANO]

setorder(C,ANO)

setEPS()
postscript("mean_ult_lance_ano.eps",width=8, height = 4)
matplot(B[,ANO],B[,2:4,with=FALSE],type = c("l"),pch=1, col = c(1,2,4), xlab = "Year", ylab = "Mean percentage of active bidders") #plot
legend("topleft", legend = c("t","t-1","t-5"), col = c(1,2,4), pch=0)
dev.off()

postscript("mean_particip_ano.eps",width=8, height = 4)
matplot(C[,ANO],C[,2:4,with=FALSE],type = c("l"),pch=1, col = c(1,2,4), xlab = "Year", ylab = "Fraction of auctions with participation") #plot
legend("topleft", legend = c("t","t-1","t-5"), col = c(1,2,4), pch=0)
dev.off()

sink("tables_glm_clm.txt")

load("time_glm.Rdata")
load("time_clm.Rdata")

stargazer(B_0,B_1,C_0,C_1, font.size = "scriptsize", no.space = TRUE,
          dep.var.labels = c("Bidders at t","Bidders at t-1",
              "Bidders at t","Bidders at t-1"),
          omit = c("20"),
          omit.labels = c("Year"),
          omit.yes.no = c("Yes","No"),
          model.names = FALSE,
          column.separate = c(2,2),
          column.labels = c("Logit","Ordered Logit"),
          covariate.labels = c("Log. Reserve Price",
              "Price Registration",
              "Small Companies Exclusivity",
              "Number of Bidders",
              "Log. Quantity",
              "Number of Bids",
              "Duration"))
sink()

load("time_negativebinomial.Rdata")

summary_negbin  <- stargazer(F_0,F_1,F_5, font.size = "scriptsize", no.space = TRUE,
                             dep.var.labels = c("Bidders at t","Bidders at t-1",
                                 "Bidders at t-5"),
                             omit.yes.no = c("Yes","No"),
                             covariate.labels = c("Log. Reserve Price",
                                 "Price Registration",
                                 "Small Companies Exclusivity",
                                 "Number of Bidders",
                                 "Log. Quantity",
                                 "Number of Bids",
                                 "Duration", "2007",
                                 "2008", "2009", "2010",
                                 "2011", "2012", "2013",
                                 "2014"))
write(summary_negbin,"tables_negbin.txt",append = FALSE)

