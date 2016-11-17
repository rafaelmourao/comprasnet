# This script opens all saved tables and print all variables and
# their types to csv file. This was used to mantain some external control
# on the huge number of variables and to double-check the sparse documentation.

path = "~/Collusion/COMPRASNET/R"
setwd(path)

writeLines("TABLE;VARIABLE;TYPE","nametypes.csv")

filenames <- dir(pattern =".rds")

for(i in 1:length(filenames)){
    tablename <-  gsub("\\.rds","",filenames[i],perl=TRUE)
    table <- readRDS(filenames[i])
    types <- lapply(table,class)
    names <- colnames(table)
    write.table(cbind(tablename,names,as.matrix(types)),file = "nametypes.csv", append = TRUE, sep = ";", row.names = FALSE, col.names = FALSE)
    rm(table)
}


listnames <- load("dicionarios.rdata")
for(i in listnames) {
    table <- get(i)
    types <- lapply(table,class)
    names <- colnames(table)
    write.table(cbind(i,names,as.matrix(types)),file = "nametypes.csv", append = TRUE, sep = ";", row.names = FALSE, col.names = FALSE)
}
rm(listnames)
rm(list = listnames)