library(SummarizedExperiment)
library(dplyr)

rna <- readRDS(file = "outputs/RDS/rna-Norm.rds")
miRs <- readRDS(file = "outputs/RDS/miRs-Norm.rds")
meth <- readRDS(file = "outputs/RDS/meth-Norm.rds")

tables.dir <- "outputs/tables"
dir.create(tables.dir,recursive = TRUE)

print("Writing Genes table")
m.rna <- assays(rna)[["unstranded"]]
m.rna <- cbind(rownames(m.rna), m.rna)
colnames(m.rna)[1] <- 'ensemble'
write.table(m.rna, file=paste0(tables.dir,'/rnas-norm.tsv'),
           quote=FALSE, sep='\t', row.names = F)

print("Writing miRNAs table")
m.miRs <- assays(miRs)[[1]]
m.miRs <- cbind(rownames(m.miRs), m.miRs)
colnames(m.miRs)[1] <- 'miRNA'
write.table(m.miRs, file=paste0(tables.dir,'/miRs-norm.tsv'),
           quote=FALSE, sep='\t', row.names = F)

m.meth <- assays(meth)[[1]]
print("Binding methylation table")
# m.meth <- cbind(rownames(m.meth), m.meth)
m.meth <- bind_cols(rownames(m.meth), m.meth)
colnames(m.meth)[1] <- 'CpGname'
print("Writing methylation table")
write.table(m.meth, file=paste0(tables.dir,'/meth-norm.tsv'),
            quote=FALSE, sep='\t', row.names = F)

