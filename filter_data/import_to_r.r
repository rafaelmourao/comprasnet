# Import all the fixed utf8 formated csv files to R and save them as .rds files with the
# correct data types. All small dictionary tables, are saved inside the "dicionario.data" file

setwd("~/Collusion/COMPRASNET/utf8")

D_CMPR_COMPRA = read.delim("D_CMPR_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", colClasses = c("integer","integer","character","character","character","character","character","character","character","integer","integer","integer","integer","integer","integer","integer","integer","integer","integer","integer","integer","character","character","integer","character","character","character","character","character","character","character","character","integer","integer","character","character","character","integer","character","integer","character"))
saveRDS(D_CMPR_COMPRA,"D_CMPR_COMPRA.rds")

F_ITEM_COMPRA <- read.delim("F_ITEM_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "",
dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE)

str(F_ITEM_COMPRA)

saveRDS(F_ITEM_COMPRA,"F_ITEM_COMPRA.rds")

rm(list =ls())

D_ITCP_ITEM_COMPRA <- read.delim("D_ITCP_ITEM_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE, encoding = "UTF-8",
colClasses = c("integer","numeric","integer","integer","character","character","character","character","character","integer","character","integer","character","integer","character","integer","character","integer","integer","numeric","integer","integer","integer","integer","numeric","numeric","character","character","character","character","character","character","integer","integer","integer","numeric","integer","character","numeric","integer","character","numeric","character"))

str(D_ITCP_ITEM_COMPRA)

saveRDS(D_ITCP_ITEM_COMPRA,"D_ITCP_ITEM_COMPRA.rds")
    
rm(list =ls())

F_ITEM_FORNECEDOR <- read.delim("F_ITEM_FORNECEDOR.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE)

str(F_ITEM_FORNECEDOR)

saveRDS(F_ITEM_FORNECEDOR,"F_ITEM_FORNECEDOR.rds")

rm(list =ls())

D_ITFN_ITEM_FORNECEDOR <- read.delim("D_ITFN_ITEM_FORNECEDOR.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", colClasses = c("integer","numeric", "integer","character","character","character","integer","integer","numeric","integer","integer","integer","integer"))

saveRDS(D_ITFN_ITEM_FORNECEDOR,"D_ITFN_ITEM_FORNECEDOR.rds") 

rm(list =ls())

D_UNDD_UNIDADE <- read.delim("D_UNDD_UNIDADE.utf8.csv", header = TRUE, sep = "\t", quote = "",
dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE ) 

str(D_UNDD_UNIDADE)

saveRDS(D_UNDD_UNIDADE,"D_UNDD_UNIDADE.rds") 

rm(list =ls())

D_ITCP_MATERIAL_SERVICO <- read.delim("D_ITCP_MATERIAL_SERVICO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", colClasses = c("numeric","integer","integer","character","integer","integer","integer","integer","character","character","integer") )

saveRDS(D_ITCP_MATERIAL_SERVICO,"D_ITCP_MATERIAL_SERVICO.rds")

D_FRND_FORNECEDOR  <-  read.delim("D_FRND_FORNECEDOR.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", colClasses = c("character","integer","character"))

saveRDS(D_FRND_FORNECEDOR,"D_FRND_FORNECEDOR.rds")                                  

rm(list=ls())

D_CMPR_FORMA_COMPRA <- read.delim("D_CMPR_FORMA_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", colClasses = c("integer","character") )

D_CMPR_INCISO_DISP_LEGAL <- read.delim("D_CMPR_INCISO_DISP_LEGAL.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", colClasses = c("integer","character"))

D_CMPR_MODALIDADE_COMPRA <- read.delim("D_CMPR_MODALIDADE_COMPRA.utf8.csv", header
 = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8",  colClasses = c("integer","integer","character"))

D_CMPR_SIT_ATUAL_COMPRA <- read.delim("D_CMPR_SIT_ATUAL_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8",  colClasses = c("integer","character"))

D_CMPR_TP_PREGAO <- read.delim("D_CMPR_TP_PREGAO.utf8.csv", header = TRUE, sep = "\t", quote ="", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8",  colClasses = c("integer","character"))

D_ITCP_PLACA_INDICADORES <- read.delim("D_ITCP_PLACA_INDICADORES.utf8.csv", header = TRUE, sep = "\t", quote =  "", dec = ".", fill = TRUE, comment.char = "")

D_ITFN_PLACA_INDICADORES <- read.delim("D_ITFN_PLACA_INDICADORES.utf8.csv", header = TRUE, sep = "\t", quote =  "", dec = ".", fill = TRUE, comment.char = "")

D_CMPR_MODALIDADE_COMPRA <- read.delim("D_CMPR_MODALIDADE_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", colClasses = c("integer","integer","character") )

D_CMPR_IN_SUBROG_COMPRA <- read.delim("D_CMPR_IN_SUBROG_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_CMPR_IN_SUBROG_COMPRA)

D_CMPR_IN_RECUR_BID_BIRD <- read.delim("D_CMPR_IN_RECUR_BID_BIRD.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_CMPR_IN_RECUR_BID_BIRD)

D_CMPR_IN_EXIST_RESULT_COMPRA <- read.delim("D_CMPR_IN_EXIST_RESULT_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_CMPR_IN_EXIST_RESULT_COMPRA)

D_CMPR_IN_SUSP_SESSAO_PUBL <- read.delim("D_CMPR_IN_SUSP_SESSAO_PUBL.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_CMPR_IN_SUSP_SESSAO_PUBL)

D_CMPR_IN_UTILIZ_ICMS_COMPRA <- read.delim("D_CMPR_IN_UTILIZ_ICMS_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_CMPR_IN_UTILIZ_ICMS_COMPRA)

D_CMPR_TP_LICITACAO <- read.delim("D_CMPR_TP_LICITACAO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_CMPR_TP_LICITACAO)

D_CMPR_IN_COTACAO_ELETR <- read.delim("D_CMPR_IN_COTACAO_ELETR.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_CMPR_IN_COTACAO_ELETR)

D_ITCP_SIT_ATUAL_ITEM <- read.delim("D_ITCP_SIT_ATUAL_ITEM.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_SIT_ATUAL_ITEM)

D_ITFN_IN_ITEM_80000 <- read.delim("D_ITFN_IN_ITEM_80000.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_IN_ITEM_80000)

D_ITFN_IN_ITEM_ELEVADO <- read.delim("D_ITFN_IN_ITEM_ELEVADO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_IN_ITEM_ELEVADO)

D_ITFN_IN_PROD_FAB_NACIONAL <- read.delim("D_ITFN_IN_PROD_FAB_NACIONAL.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_IN_PROD_FAB_NACIONAL)

D_ITFN_PAIS_FAB_PRODUTO <- read.delim("D_ITFN_PAIS_FAB_PRODUTO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_PAIS_FAB_PRODUTO)

D_ITFN_CLASSIF_FORNEC <- read.delim("D_ITFN_CLASSIF_FORNEC.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_CLASSIF_FORNEC)

D_ITFN_SIT_FORNEC_COMPRA <- read.delim("D_ITFN_SIT_FORNEC_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE,colClasses = c("integer","character"))

str(D_ITFN_SIT_FORNEC_COMPRA)

D_UNDD_ESFERA <- read.delim("D_UNDD_ESFERA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE,colClasses = c("integer","character"))

str(D_UNDD_ESFERA)

D_UNDD_IN_UTILIZ_SIAFI <- read.delim("D_UNDD_IN_UTILIZ_SIAFI.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_UNDD_IN_UTILIZ_SIAFI)

D_UNDD_IN_SISG <- read.delim("D_UNDD_IN_SISG.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_UNDD_IN_SISG)

D_LCAL_MUNICIPIO <- read.delim("D_LCAL_MUNICIPIO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character","character","character"))

str(D_LCAL_MUNICIPIO)

D_LCAL_UF <- read.delim("D_LCAL_UF.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("character","character","character"))

str(D_LCAL_UF)

D_LCAL_REGIAO <- read.delim("D_LCAL_REGIAO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("character","character","character"))

str(D_LCAL_REGIAO)

D_UNDD_ORGAO <- read.delim("D_UNDD_ORGAO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character","integer","integer"))

str(D_UNDD_ORGAO)

D_UNDD_SIT_ATUAL_UNIDADE <- read.delim("D_UNDD_SIT_ATUAL_UNIDADE.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_UNDD_SIT_ATUAL_UNIDADE)

D_UNDD_TP_ADM <- read.delim("D_UNDD_TP_ADM.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_UNDD_TP_ADM)

D_UNDD_IN_ADESAO_SIASG <- read.delim("D_UNDD_IN_ADESAO_SIASG.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_UNDD_IN_ADESAO_SIASG)

D_ITCP_TP_MATERIAL_SERVICO <- read.delim("D_ITCP_TP_MATERIAL_SERVICO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_TP_MATERIAL_SERVICO)

D_ITCP_CLASSE_MAT_SERV <- read.delim("D_ITCP_CLASSE_MAT_SERV.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character","integer", "integer","integer"))

str(D_ITCP_CLASSE_MAT_SERV)

D_ITCP_PADRAO_DESC_MAT <- read.delim("D_ITCP_PADRAO_DESC_MAT.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("character","character"))

str(D_ITCP_PADRAO_DESC_MAT)

D_ITCP_SIT_ATUAL_MAT_SERV <- read.delim("D_ITCP_SIT_ATUAL_MAT_SERV.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_SIT_ATUAL_MAT_SERV)

D_ITCP_GRUPO_MATERIAL <- read.delim("D_ITCP_GRUPO_MATERIAL.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_GRUPO_MATERIAL)

D_ITCP_GRUPO_SERVICO <- read.delim("D_ITCP_GRUPO_SERVICO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_GRUPO_SERVICO)

D_ITCP_IN_SUSTENTAVEL <- read.delim("D_ITCP_IN_SUSTENTAVEL.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_SUSTENTAVEL)

D_ITCP_IN_EXIST_CONTRATO <- read.delim("D_ITCP_IN_EXIST_CONTRATO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_EXIST_CONTRATO)

D_ITCP_IN_RENEG_ITEM_SRP <- read.delim("D_ITCP_IN_RENEG_ITEM_SRP.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_RENEG_ITEM_SRP)

D_ITCP_IN_ITEM_SEMEL_UASG <- read.delim("D_ITCP_IN_ITEM_SEMEL_UASG.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_ITEM_SEMEL_UASG)

D_ITCP_IN_COTACAO_ELETR <- read.delim("D_ITCP_IN_COTACAO_ELETR.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_COTACAO_ELETR)

D_ITCP_TP_BENEF_ME_EPP <- read.delim("D_ITCP_TP_BENEF_ME_EPP.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character","character"))

str(D_ITCP_TP_BENEF_ME_EPP)

D_ITFN_IN_FORNEC_ACEITO <- read.delim("D_ITFN_IN_FORNEC_ACEITO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_IN_FORNEC_ACEITO)

D_ITFN_IN_FORNEC_HABILITADO <- read.delim("D_ITFN_IN_FORNEC_HABILITADO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_IN_FORNEC_HABILITADO)

D_ITFN_IN_FORNEC_SOCIO_COMPRA <- read.delim("D_ITFN_IN_FORNEC_SOCIO_COMPRA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_IN_FORNEC_SOCIO_COMPRA)

D_ITFN_IN_REPRES_FORNEC <- read.delim("D_ITFN_IN_REPRES_FORNEC.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_IN_REPRES_FORNEC)

D_ITFN_IN_SUBCONTRATADA <- read.delim("D_ITFN_IN_SUBCONTRATADA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_IN_SUBCONTRATADA)

D_ITCP_IN_DESEMPATE_ME_EPP <- read.delim("D_ITCP_IN_DESEMPATE_ME_EPP.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_DESEMPATE_ME_EPP)

D_ITFN_TP_DECLAR_BENEF_7174 <- read.delim("D_ITFN_TP_DECLAR_BENEF_7174.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", encoding = "UTF-8", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITFN_TP_DECLAR_BENEF_7174)

D_ITCP_IN_PART_ABERTA <- read.delim("D_ITCP_IN_PART_ABERTA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_PART_ABERTA)

D_ITCP_TP_CRITERIO_JULG <- read.delim("D_ITCP_TP_CRITERIO_JULG.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE,colClasses = c("integer","character"))

str(D_ITCP_TP_CRITERIO_JULG)

D_ITCP_IN_COMPRA_GRUPO <- read.delim("D_ITCP_IN_COMPRA_GRUPO.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_COMPRA_GRUPO)

D_ITCP_IN_DESEMPATE_7174 <- read.delim("D_ITCP_IN_DESEMPATE_7174.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_DESEMPATE_7174)

D_ITCP_IN_BENEF_7174 <- read.delim("D_ITCP_IN_BENEF_7174.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_BENEF_7174)

D_ITCP_IN_PART_ABERTA <- read.delim("D_ITCP_IN_PART_ABERTA.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_PART_ABERTA)

D_ITCP_IN_PRORR_ATA_SRP <- read.delim("D_ITCP_IN_PRORR_ATA_SRP.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_PRORR_ATA_SRP)

D_ITCP_IN_PREF_PROD_NACIONAL <- read.delim("D_ITCP_IN_PREF_PROD_NACIONAL.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_PREF_PROD_NACIONAL)

D_ITCP_IN_PREF_PROD_ADICIONAL <- read.delim("D_ITCP_IN_PREF_PROD_ADICIONAL.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_ITCP_IN_PREF_PROD_ADICIONAL)

D_UNDD_PODER <- read.delim("D_UNDD_PODER.utf8.csv", header = TRUE, sep = "\t", quote = "", dec = ".", fill = TRUE, comment.char = "", stringsAsFactors=FALSE, colClasses = c("integer","character"))

str(D_UNDD_PODER)

save.image("dicionarios.rdata")

