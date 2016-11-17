# This script builds on the table constructed by the script "construct_table_pregao"
# to add duration-related variables and run a few models for explaining bids on the
# last moments of the auctions
library(data.table)
path = "~/Collusion/COMPRASNET/R_pregoes"
setwd(path)


hour_to_minutes  <- function(x) {
  padded_x  <- sprintf("%04d",x)
  60*as.integer(substr(padded_x,1,2)) + as.integer(substr(padded_x,3,4))
}


F_ITEM_COMPRA  <- readRDS("F_ITEM_COMPRA_filtered.rds")
D_ITCP_ITEM_COMPRA  <- readRDS("D_ITCP_ITEM_COMPRA.rds")

setkey(F_ITEM_COMPRA,ID_ITCP_ITEM_COMPRA)
setkey(D_ITCP_ITEM_COMPRA,ID_ITCP_ITEM_COMPRA)

# Presential pregoes don't have a random ending time
F_ITEM_COMPRA  <- F_ITEM_COMPRA[PRESENCIAL != TRUE]

# Get opening and closing auction times from D_ITCP_ITEM_COMPRA
# using the data.table merge syntax
F_ITEM_COMPRA[D_ITCP_ITEM_COMPRA, `:=`(
  HO_ABERTURA_ITEM = i.HO_ABERTURA_ITEM, HO_ENCERRAMENTO_ITEM = i.HO_ENCERRAMENTO_ITEM,
  DT_ABERTURA_ITEM = i.DT_ABERTURA_ITEM, DT_ENCERRAMENTO_ITEM = i.DT_ENCERRAMENTO_ITEM)]

# Converting this times into a minute count and calculating the duration
F_ITEM_COMPRA[, `:=`(HO_ABERTURA_ITEM_MIN = hour_to_minutes(HO_ABERTURA_ITEM),
                     HO_ENCERRAMENTO_ITEM_MIN = hour_to_minutes(HO_ENCERRAMENTO_ITEM))]
F_ITEM_COMPRA[,DURATION := HO_ENCERRAMENTO_ITEM_MIN - HO_ABERTURA_ITEM_MIN]

#Doing a check
head(F_ITEM_COMPRA[,.(HO_ABERTURA_ITEM,HO_ABERTURA_ITEM_MIN,
                      HO_ENCERRAMENTO_ITEM,HO_ENCERRAMENTO_ITEM_MIN,DURATION)])


F_ITEM_FORNECEDOR <- readRDS("F_ITEM_FORNECEDOR.rds")
D_ITFN_ITEM_FORNECEDOR  <- readRDS("D_ITFN_ITEM_FORNECEDOR.rds")

setkey(D_ITFN_ITEM_FORNECEDOR,ID_ITFN_ITEM_FORNECEDOR)
setkey(F_ITEM_FORNECEDOR,ID_ITFN_ITEM_FORNECEDOR)

# Getting the total number of bids for each participant and their last bidding time
TIME_LANCES  <-  D_ITFN_ITEM_FORNECEDOR[F_ITEM_FORNECEDOR,
                                        .(ID_ITFN_ITEM_FORNECEDOR,ID_ITCP_ITEM_COMPRA,
                                          QT_ITFN_LANCES_ITEM_FORNEC,HO_ULT_LANCE_FORNEC)]

setkey(TIME_LANCES,ID_ITCP_ITEM_COMPRA)

# Getting the relevant variables from F_ITEM_COMPRA and merging with previous result
TIME_LANCES  <- TIME_LANCES[F_ITEM_COMPRA,.(
  ID_ITFN_ITEM_FORNECEDOR,ID_ITCP_ITEM_COMPRA,QT_ITFN_LANCES_ITEM_FORNEC,
  HO_ULT_LANCE_FORNEC, HO_ENCERRAMENTO_ITEM_MIN, HO_ABERTURA_ITEM_MIN)]
TIME_LANCES[,HO_ULT_LANCE_FORNEC_MIN := hour_to_minutes(HO_ULT_LANCE_FORNEC)]

# Finally calculating the target variables
TIME_LANCES_2  <- TIME_LANCES[,.(ULT_LANCE_0 = sum( HO_ULT_LANCE_FORNEC_MIN -
                                                      HO_ENCERRAMENTO_ITEM_MIN == 0),
                                 
                                 ULT_LANCE_1 = sum( HO_ULT_LANCE_FORNEC_MIN -
                                                      HO_ENCERRAMENTO_ITEM_MIN > -2),
                                 
                                 ULT_LANCE_5 = sum( HO_ULT_LANCE_FORNEC_MIN -
                                                      HO_ENCERRAMENTO_ITEM_MIN > -6),
                                 
                                 ULT_LANCE_NO_TIME = all(HO_ULT_LANCE_FORNEC == 0),
                                 
                                 FECHAMENTO_WRONG_TIME = any(
                                   HO_ULT_LANCE_FORNEC_MIN > HO_ENCERRAMENTO_ITEM_MIN 
                                   | HO_ENCERRAMENTO_ITEM_MIN == 0),
                                 
                                 ABERTURA_WRONG_TIME = ( all( 
                                   HO_ULT_LANCE_FORNEC_MIN < HO_ABERTURA_ITEM_MIN) &
                                     any( QT_ITFN_LANCES_ITEM_FORNEC > 1 ) ) |
                                   any(HO_ABERTURA_ITEM_MIN == 0) ),
                              
                              by = ID_ITCP_ITEM_COMPRA]

F_ITEM_COMPRA  <-  merge(F_ITEM_COMPRA, TIME_LANCES_2)

rm(F_ITEM_FORNECEDOR,D_ITCP_ITEM_COMPRA,D_ITFN_ITEM_FORNECEDOR,TIME_LANCES,TIME_LANCES_2)

saveRDS(F_ITEM_COMPRA,"F_ITEM_COMPRA_filtered_times.rds")
