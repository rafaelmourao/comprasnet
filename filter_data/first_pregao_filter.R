# This script runs a first filter on the data, removing useless character variables
# as for example long product description and name of auctioneers. We keep only
# processes with well defined dates and results. Other files run more thorough filters
# to construct tables more suited to some tests.

library(data.table)
path = "~/Collusion/COMPRASNET/R_new/"
newpath = "~/Collusion/COMPRASNET/R_pregoes/"
setwd(path)

# Function to remove chars from a data table since we may not need them
remove_chars  <-  function(arg) {
    set(arg,j=which(sapply(arg, function(x) is.character(x) && !is.factor(x))), value = NULL)
}

D_CMPR_COMPRA  <- readRDS("D_CMPR_COMPRA.rds")
setDT(D_CMPR_COMPRA)
remove_chars(D_CMPR_COMPRA) 

# Keeping only "Pregoes" with non-missing dates
D_CMPR_COMPRA  <- D_CMPR_COMPRA[DS_CMPR_MODALIDADE_COMPRA == "Pregão"
                                & DT_REFERENCIA_COMPRA != "2000-01-01"
                                & DS_CMPR_IN_EXIST_RESULT_COMPRA == "Existe Resultado de Compra"]

F_ITEM_COMPRA  <- readRDS("F_ITEM_COMPRA.rds")
setDT(F_ITEM_COMPRA)
remove_chars(F_ITEM_COMPRA)

# Keeping only the pregoes itens that had sucessful ending (more filters should be added to the pregoes)
ITENS_KEEP <- F_ITEM_COMPRA[, (keep = ID_CMPR_COMPRA %in% D_CMPR_COMPRA[,ID_CMPR_COMPRA] &
                                ID_ITCP_SIT_ATUAL_ITEM == 1)]
F_ITEM_COMPRA <- F_ITEM_COMPRA[ITENS_KEEP]

D_ITCP_ITEM_COMPRA <- readRDS("D_ITCP_ITEM_COMPRA.rds")
setDT(D_ITCP_ITEM_COMPRA)
remove_chars(D_ITCP_ITEM_COMPRA)
D_ITCP_ITEM_COMPRA <- D_ITCP_ITEM_COMPRA[ID_ITCP_ITEM_COMPRA %in% F_ITEM_COMPRA[,ID_ITCP_ITEM_COMPRA]]

# Keeping only suppliers/items not filtered out, and adding values and participation
# info to F_ITEM_COMPRA

F_ITEM_FORNECEDOR <- readRDS("F_ITEM_FORNECEDOR.rds")
setDT(F_ITEM_FORNECEDOR)

#remove_chars(F_ITEM_FORNECEDOR)

F_ITEM_FORNECEDOR <- F_ITEM_FORNECEDOR[ID_ITCP_ITEM_COMPRA %in% F_ITEM_COMPRA[,ID_ITCP_ITEM_COMPRA]]
RF_PRECO_HOMOLOGADO <- F_ITEM_FORNECEDOR[,.(VL_PRECO_UNIT_HOMOLOG = max(VL_PRECO_UNIT_HOMOLOG),
                                          VL_PRECO_TOTAL_HOMOLOG = max(VL_PRECO_TOTAL_HOMOLOG),
                                          QT_FORNEC_PARTICIP_ITEM = .N),
                                          by=ID_ITCP_ITEM_COMPRA]

setkey(F_ITEM_COMPRA,ID_ITCP_ITEM_COMPRA)
setkey(RF_PRECO_HOMOLOGADO,ID_ITCP_ITEM_COMPRA)
F_ITEM_COMPRA <- merge(F_ITEM_COMPRA,RF_PRECO_HOMOLOGADO)

#updating D_ITFN_ITEM_FORNECEDOR, D_ITCP_ITEM_COMPRA and D_CMPR_COMPRA

D_ITFN_ITEM_FORNECEDOR <- readRDS("D_ITFN_ITEM_FORNECEDOR.rds")
setDT(D_ITFN_ITEM_FORNECEDOR)
remove_chars(D_ITFN_ITEM_FORNECEDOR)
D_ITFN_ITEM_FORNECEDOR  <- D_ITFN_ITEM_FORNECEDOR[ID_ITFN_ITEM_FORNECEDOR %in%
                                                  F_ITEM_FORNECEDOR[,ID_ITFN_ITEM_FORNECEDOR]]

D_ITCP_ITEM_COMPRA  <- D_ITCP_ITEM_COMPRA[ID_ITCP_ITEM_COMPRA %in% F_ITEM_COMPRA[,ID_ITCP_ITEM_COMPRA]]
D_CMPR_COMPRA  <- D_CMPR_COMPRA[ID_CMPR_COMPRA %in% unique(F_ITEM_COMPRA[,ID_CMPR_COMPRA])]

D_UNDD_UNIDADE  <- readRDS("D_UNDD_UNIDADE.rds")
D_FRND_FORNECEDOR  <- readRDS("D_FRND_FORNECEDOR.rds")
D_ITCP_MATERIAL_SERVICO  <- readRDS("D_ITCP_MATERIAL_SERVICO.rds")

setDT(D_UNDD_UNIDADE)
setDT(D_FRND_FORNECEDOR)
setDT(D_ITCP_MATERIAL_SERVICO)

D_FRND_FORNECEDOR  <- D_FRND_FORNECEDOR[
  ID_FRND_FORNECEDOR %in% unique(F_ITEM_FORNECEDOR$ID_FRND_FORNECEDOR_COMPRA)]

#saving everything to new path

setwd(newpath)
saveRDS(D_CMPR_COMPRA,"D_CMPR_COMPRA.rds")
saveRDS(F_ITEM_FORNECEDOR,"F_ITEM_FORNECEDOR.rds")
saveRDS(D_ITCP_ITEM_COMPRA,"D_ITCP_ITEM_COMPRA.rds")
saveRDS(D_ITFN_ITEM_FORNECEDOR,"D_ITFN_ITEM_FORNECEDOR.rds")
saveRDS(F_ITEM_COMPRA,"F_ITEM_COMPRA.rds")
saveRDS(D_UNDD_UNIDADE,"D_UNDD_UNIDADE.rds")
saveRDS(D_FRND_FORNECEDOR,"D_FRND_FORNECEDOR.rds")
saveRDS(D_ITCP_MATERIAL_SERVICO,"D_ITCP_MATERIAL_SERVICO.rds")

#cleaning workspace and doing garbage collection
rm(list=ls())
gc()                                                  
                                                  
                                                  
                                             
