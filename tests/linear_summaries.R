# Construct a few regression tables for the reports

library(data.table)
library(stargazer)
path = "~/Collusion/COMPRASNET/R_pregoes"
setwd(path)

F_ITEM_COMPRA  <- readRDS("F_ITEM_COMPRA_filtered_no_outliers.rds")
F_ITEM_COMPRA  <- F_ITEM_COMPRA[ANO<2015]

A  <- lm(R_PRECO~log(VL_ITCP_PRECO_GLOBAL_ESTIM)+PRESENCIAL+SRP+ME_EX+
           QT_FORNEC_PARTICIP_ITEM+I(QT_FORNEC_PARTICIP_ITEM^2)+log(QT_ITCP_SOLICITADA)+
           factor(DS_LCAL_UF_UNIDADE)+factor(ANO),data=F_ITEM_COMPRA)
summary(A)

B  <- lm(log(VL_PRECO_UNIT_HOMOLOG)~log(VL_ITCP_PRECO_UNIT_ESTIM)+PRESENCIAL+SRP+
           ME_EX+QT_FORNEC_PARTICIP_ITEM+I(QT_FORNEC_PARTICIP_ITEM^2)+log(QT_ITCP_SOLICITADA)+
           factor(DS_LCAL_UF_UNIDADE)+factor(ANO),data=F_ITEM_COMPRA)
summary(B)

C <-  lm(log(VL_PRECO_UNIT_HOMOLOG)~log(VL_ITCP_PRECO_UNIT_ESTIM),data=F_ITEM_COMPRA[ANO<2015])
summary(C)

sink("tables_variance_lm.txt")
lma  <- stargazer(A, font.size = "scriptsize", single.row = TRUE,
                  dep.var.labels = c("Winning Bid/Reference Price"),
                  omit = c("DS_LCAL_UF_UNIDADE", "20"),
                  omit.labels = c("State","Year"),
                  omit.yes.no = c("Yes","No"),
                  covariate.labels = c("Log. Reserve Price",
                      "Presential Auction",
                      "Price Registration",
                      "Small Companies Exclusivity",
                      "Number of Bidders",
                      "Sq. Numbers of Bidders",
                      "Log. Quantity"))

lmb  <- stargazer(B, font.size = "scriptsize", single.row = TRUE,
                  dep.var.labels = c("Log. Winning Bid"),
                  omit = c("DS_LCAL_UF_UNIDADE", "20"),
                  omit.labels = c("State","Year"),
                  omit.yes.no = c("Yes","No"),
                  covariate.labels = c("Log. Reserve Price",
                      "Presential Auction",
                      "Price Registration",
                      "Small Companies Exclusivity",
                      "Number of Bidders",
                      "Sq. Numbers of Bidders",
                      "Log. Quantity"))

sink()
