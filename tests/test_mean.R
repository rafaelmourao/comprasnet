# This script builds a simple regression model to predict departures from the expected price
# (predicted by market research). It generates then a few plots and reports on the distribution
# of the residuals for the most popular classes of product (for two different classifications)

library(data.table)

path = "~/Collusion/COMPRASNET/R_pregoes"
setwd(path)

F_ITEM_COMPRA  <- readRDS("F_ITEM_COMPRA_filtered_no_outliers.rds")
F_ITEM_COMPRA  <- F_ITEM_COMPRA[ANO<2015]

# Run simple, linear regression method
A  <- lm(log(VL_PRECO_UNIT_HOMOLOG)~log(VL_ITCP_PRECO_UNIT_ESTIM)+
           PRESENCIAL+SRP+ME_EX+QT_FORNEC_PARTICIP_ITEM+I(QT_FORNEC_PARTICIP_ITEM^2)+
           log(QT_ITCP_SOLICITADA)+factor(DS_LCAL_UF_UNIDADE)+factor(ANO),data=F_ITEM_COMPRA)
summary(A)

residA  <- resid(A)
F_ITEM_COMPRA[,residA := residA]   

# By CATMAT classification

# generate two residual tables, by class and by class and state
Z  <- F_ITEM_COMPRA[,.(freq = .N, meanresidA = mean(residA)),
                    by = .(ID_ITCP_CLASSE_MAT_SERV,DS_ITCP_CLASSE_MAT_SERV)]
Z2  <- F_ITEM_COMPRA[,.(freq = .N, meanresidA = mean(residA)),
                     by = .(ID_ITCP_CLASSE_MAT_SERV,DS_ITCP_CLASSE_MAT_SERV,DS_LCAL_UF_UNIDADE)]

setorder(Z2,DS_LCAL_UF_UNIDADE)
setorder(Z,-meanresidA)

# table with all residual means
write.table(Z, "prod_mean_classmat_all.txt", sep="\t", quote=FALSE, row.names=FALSE)

setorder(Z,-freq)
Z  <- Z[1:100]
setorder(Z,-meanresidA)

# table with the residual means only for the 100 most popular classes
write.table(Z, "prod_mean_classmat.txt", sep="\t", quote=FALSE, row.names=FALSE)
setorder(Z,-freq)

# create a few figures
dir.create("figures/mean_classmat")
for (i in 1:100) {
    print(i)
    prod  <- Z[i,DS_ITCP_CLASSE_MAT_SERV]
    png(paste0("figures/mean_classmat/test_mean_CLASSMAT_UF_",i,".png"))
    plot_title  <- paste(strwrap(prod,width=50),collapse = "\n")
    xx  <- Z2[DS_ITCP_CLASSE_MAT_SERV == prod, barplot(meanresidA,names.arg = DS_LCAL_UF_UNIDADE,las=2,cex.axis=0.7,main=plot_title)]
  #  Z2[DS_ITCP_CLASSE_MAT_SERV == prod,text(x = xx, y = meanresid1, label = freq, pos = sign(meanresid1)+2, cex = 0.7, srt = 90, col = "red", offset=5)]
    dev.off()
}

# table with the residual means by states
Z2 <- Z2[ID_ITCP_CLASSE_MAT_SERV %in% Z$ID_ITCP_CLASSE_MAT_SERV]
Z2 <- Z2[order(match(Z2$ID_ITCP_CLASSE_MAT_SERV,Z$ID_ITCP_CLASSE_MAT_SERV))]
write.table(Z2, "prod_mean_classmat_uf.txt", sep="\t", quote=FALSE, row.names=FALSE)

### PADMAT
## same as above

Z  <- F_ITEM_COMPRA[,.(freq = .N, meanresidA = mean(residA)),
                    by = .(ID_ITCP_PADRAO_DESC_MAT,DS_ITCP_PADRAO_DESC_MAT)]
Z2  <- F_ITEM_COMPRA[,.(freq = .N, meanresidA = mean(residA)),
                     by = .(ID_ITCP_PADRAO_DESC_MAT,DS_ITCP_PADRAO_DESC_MAT,DS_LCAL_UF_UNIDADE)]
setorder(Z2,DS_LCAL_UF_UNIDADE)

setorder(Z,-freq)
setorder(Z,-meanresidA)
write.table(Z, "prod_mean_padmat_all.txt", sep="\t")

setorder(Z,-freq)
Z  <- Z[1:100]
setorder(Z,-meanresidA)

write.table(Z, "prod_mean_padmat.txt", sep="\t")
setorder(Z,-freq)

dir.create("figures/mean_padmat")
for (i in 1:100) {
    print(i)
    prodn  <- Z[i,ID_ITCP_PADRAO_DESC_MAT]
    prod  <- Z[i,DS_ITCP_PADRAO_DESC_MAT]
    png(paste0("figures/mean_padmat/mean_PADMAT_UF_",i,".png"))
    plot_title  <- paste(strwrap(prod,width=50),collapse = "\n")
    xx  <- Z2[ID_ITCP_PADRAO_DESC_MAT == prodn, barplot(meanresidA,names.arg = as.character(DS_LCAL_UF_UNIDADE),las=2,cex.axis=0.7,main=plot_title)]
  #  Z2[DS_ITCP_CLASSE_MAT_SERV == prod,text(x = xx, y = meanresidA, label = freq, pos = sign(meanresidA)+2, cex = 0.7, srt = 90, col = "red", offset=5)]
    dev.off()
}


Z2 <- Z2[ID_ITCP_PADRAO_DESC_MAT %in% Z$ID_ITCP_PADRAO_DESC_MAT]
Z2 <- Z2[order(match(Z2$ID_ITCP_PADRAO_DESC_MAT,Z$ID_ITCP_PADRAO_DESC_MAT))]
write.table(Z2, "prod_mean_padmat_uf.txt", sep="\t", quote=FALSE, row.names=FALSE)
