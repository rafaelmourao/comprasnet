# This script uses the results from the time regressions to test the mean prediction error by category, 
# similarly to what is done with the simple linear model. The pattern by market seems to be 
# similar no matter the model used. Here I report the results for the Logit model, but
# very few changes are needed to run the same for the other estimated models. 

library(data.table)
library(stargazer)
library(MASS)
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

load("time_glm.Rdata")

F_ITEM_COMPRA[,`:=`(resid0 = resid(B_0,"response"), resid1 = resid(B_1,"response"), 
                    resid5 =resid(B_5,"response"))]   
  
table_time  <- F_ITEM_COMPRA[,.(freq = .N, meanresid0 = mean(resid0),
                       meanresid1 = mean(resid1), meanresid5 = mean(resid5)),
                    by = .(ID_ITCP_CLASSE_MAT_SERV,DS_ITCP_CLASSE_MAT_SERV)]

table_time_uf  <- F_ITEM_COMPRA[,.(freq = .N, meanresid0 = mean(resid0),
                        meanresid1 = mean(resid1), meanresid5 = mean(resid5)),
                     by = .(ID_ITCP_CLASSE_MAT_SERV,DS_ITCP_CLASSE_MAT_SERV,DS_LCAL_UF_UNIDADE)]

setorder(table_time_df,DS_LCAL_UF_UNIDADE)
setorder(table_time,meanresid1)

write.table(table_time, "prod_time_classmat_all.txt", sep="\t", quote=FALSE, row.names=FALSE)

setorder(table_time,-freq)
table_time  <- table_time[1:100]
setorder(table_time,meanresid1)

write.table(table_time, "prod_time_classmat.txt", sep="\t", quote=FALSE, row.names=FALSE)
setorder(table_time,-freq)

dir.create("figures/times_classmat")
for (i in 1:100) {
    print(i)
    prod  <- table_time[i,DS_ITCP_CLASSE_MAT_SERV]
    png(paste0("figures/times_classmat/test_time_CLASSMAT_UF_",i,".png"))
    plot_title  <- paste(strwrap(prod,width=50),collapse = "\n")
    xx  <- table_time_uf[DS_ITCP_CLASSE_MAT_SERV == prod, barplot(
      meanresid1,names.arg = DS_LCAL_UF_UNIDADE,las=2,cex.axis=0.7,main=plot_title)]
  #  table_time_uf[DS_ITCP_CLASSE_MAT_SERV == prod,text(x = xx, y = meanresid1, 
  #  label = freq, pos = sign(meanresid1)+2, cex = 0.7, srt = 90, col = "red", offset=5)]
    dev.off()
}

table_time_uf <- table_time_uf[ID_ITCP_CLASSE_MAT_SERV %in% Z$ID_ITCP_CLASSE_MAT_SERV]
table_time_uf <- table_time_uf[order(match(table_time_uf$ID_ITCP_CLASSE_MAT_SERV,
                                table_time$ID_ITCP_CLASSE_MAT_SERV))]
write.table(table_time_uf, "prod_time_classmat_uf.txt", sep="\t", quote=FALSE, row.names=FALSE)

### PADMAT

table_time  <- F_ITEM_COMPRA[,.(freq = .N, meanresid0 = mean(resid0),
                       meanresid1 = mean(resid1), meanresid5 = mean(resid5)),
                    by = .(ID_ITCP_PADRAO_DESC_MAT,DS_ITCP_PADRAO_DESC_MAT)]
table_time_uf  <- F_ITEM_COMPRA[,.(freq = .N, meanresid0 = mean(resid0),
                        meanresid1 = mean(resid1), meanresid5 = mean(resid5)),
                     by = .(ID_ITCP_PADRAO_DESC_MAT,DS_ITCP_PADRAO_DESC_MAT,DS_LCAL_UF_UNIDADE)]
setorder(table_time_uf,DS_LCAL_UF_UNIDADE)


setorder(table_time,-freq)
setorder(table_time,meanresid1)
write.table(table_time, "prod_time_padmat_all.txt", sep="\t")

setorder(table_time,-freq)
table_time  <- table_time[1:100]
setorder(table_time,meanresid1)

write.table(table_time, "prod_time_padmat.txt", sep="\t")
setorder(table_time,-freq)

dir.create("figures/times_padmat")
for (i in 1:100) {
    print(i)
    prodn  <- table_time[i,ID_ITCP_PADRAO_DESC_MAT]
    prod  <- table_time[i,DS_ITCP_PADRAO_DESC_MAT]
    png(paste0("figures/times_padmat/test_time_PADMAT_UF_",i,".png"))
    plot_title  <- paste(strwrap(prod,width=50),collapse = "\n")
    xx  <- table_time_uf[ID_ITCP_PADRAO_DESC_MAT == prodn, 
              barplot(meanresid1,names.arg = as.character(DS_LCAL_UF_UNIDADE),
                      las=2,cex.axis=0.7,main=plot_title)]
  #  table_time[DS_ITCP_CLASSE_MAT_SERV == prod,text(x = xx, 
  #  y = meanresid1, label = freq, pos = sign(meanresid1)+2,
  #  cex = 0.7, srt = 90, col = "red", offset=5)]
    dev.off()
}


table_time_uf <- table_time_uf[ID_ITCP_PADRAO_DESC_MAT %in% Z$ID_ITCP_PADRAO_DESC_MAT]
table_time_uf <- table_time_uf[order(match(Z2$ID_ITCP_PADRAO_DESC_MAT,Z$ID_ITCP_PADRAO_DESC_MAT))]
write.table(table_time_uf, "prod_time_padmat_uf.txt", sep="\t", quote=FALSE, row.names=FALSE)
