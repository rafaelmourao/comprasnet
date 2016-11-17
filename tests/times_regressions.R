# Runs several regression models for the timing problem

library(data.table)
library(ordinal)
library(MASS)
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


summary(F_ITEM_COMPRA$DURATION)

explanatory_vars  <- paste("log(VL_ITCP_PRECO_UNIT_ESTIM) + SRP + ME_EX +",
"QT_FORNEC_PARTICIP_ITEM + log(QT_ITCP_SOLICITADA) + QT_ITCP_LANCES_ITEM +",
"DURATION + factor(ANO)")

reg_build  <- function(x) { as.formula(paste(x," ~ ",explanatory_vars)) }

# Basic linear model

A_0  <- lm(reg_build("ULT_LANCE_0"), data=F_ITEM_COMPRA)
summary(A_0)

A_1  <- lm(reg_build("ULT_LANCE_1"), data=F_ITEM_COMPRA)
summary(A_1)

A_5  <- lm(reg_build("ULT_LANCE_5"), data=F_ITEM_COMPRA)
summary(A_5)

save(file = "time_lm.Rdata", list = c("A_0","A_1","A_5"))
rm(A_0,A_1,A_5)

## Logit Model

F_ITEM_COMPRA[,`:=`(ANY_ULT_LANCE_0 = ( ULT_LANCE_0 > 0 ),
                    ANY_ULT_LANCE_1 = ( ULT_LANCE_1 > 0 ),
                    ANY_ULT_LANCE_5 = ( ULT_LANCE_5 > 0 ))]

B_0 <- glm(reg_build("ANY_ULT_LANCE_0"), family=binomial(link="logit"), data=F_ITEM_COMPRA)
B_0$data <- NULL
summary(B_0)

B_1  <- glm(reg_build("ANY_ULT_LANCE_1"), family=binomial(link="logit"), data=F_ITEM_COMPRA)
B_1$data <- NULL
summary(B_1)

B_5  <- glm(reg_build("ANY_ULT_LANCE_5"), family=binomial(link="logit"),data=F_ITEM_COMPRA)
B_5$data  <-  NULL
summary(B_5)

save(file = "time_glm.Rdata", list = c("B_0","B_1","B_5"))
rm(B_0,B_1,B_5)

# Ordered logit model

library(ordinal)

C_0  <- clm(reg_build("ordered(ULT_LANCE_0)"), link="logit", data=F_ITEM_COMPRA)
C_0$data  <-  NULL
C_0$model  <-  NULL
summary(C_0)

C_1  <-  clm(reg_build("ordered(ULT_LANCE_1)"), link="logit", data=F_ITEM_COMPRA)
C_1$data  <-  NULL
C_1$model  <-  NULL
summary(C_1)

C_5  <-  clm(reg_build("ordered(ULT_LANCE_5)"), link="logit",data=F_ITEM_COMPRA)
C_5$model  <-  NULL
C_5$data  <-  NULL
summary(C_5)

save(file = "time_clm.Rdata", list = c("C_0","C_1","C_5"))
rm(C_0,C_1,C_5)

str(F_ITEM_COMPRA)

# Poisson model

load("time_clm.Rdata")

D_0 <- glm(reg_build("ULT_LANCE_0"), family=poisson(), data=F_ITEM_COMPRA)
summary(D_0)

D_1  <- glm(reg_build("ULT_LANCE_1"), family=poisson(), data=F_ITEM_COMPRA)
summary(D_1)

D_5  <- glm(reg_build("ULT_LANCE_5"), family=poisson(),data=F_ITEM_COMPRA)
summary(D_5)

save(file = "time_poisson.Rdata", list = c("D_0","D_1","D_5"))
rm(D_0,D_1,D_5)


# Quasi poisson model

E_0 <- glm(reg_build("ULT_LANCE_0"), family=quasipoisson, data=F_ITEM_COMPRA)
summary(E_0)

E_1  <- glm(reg_build("ULT_LANCE_1"), family=quasipoisson, data=F_ITEM_COMPRA)
summary(E_1)

E_5  <- glm(reg_build("ULT_LANCE_5"), family=quasipoisson,data=F_ITEM_COMPRA)
summary(E_5)

save(file = "time_quasipoisson.Rdata", list = c("E_0","E_1","E_5"))
rm(E_0,E_1,E_5)

# Negative binomial model

F_0  <- glm.nb(reg_build("ULT_LANCE_0"), data = F_ITEM_COMPRA)
summary(F_0)

F_1  <- glm.nb(reg_build("ULT_LANCE_1"), data = F_ITEM_COMPRA)
summary(F_1)

F_5  <- glm.nb(reg_build("ULT_LANCE_5"), data = F_ITEM_COMPRA)
summary(F_5)

save(file = "time_negativebinomial.Rdata", list = c("F_0","F_1","F_5"))
rm(F_0,F_1,F_5)

