library(NOISeq)
library(SummarizedExperiment)

source("R/tools.R")

rna <- readRDS(file = "outputs/RDS/rna-cleanCols.rds")
dim(rna)

###############################################
#! Plot PCA pre-clean 
pca.grupo(rna,"outputs/plots/PCA-rna-preClean.png",'sample_type')


###############################################
#! Annotate RNAs

###############################################
#! CLEAN
#! Clean RNAs by protein coding
df <- as.data.frame(rowData(rna))
genes <- df$gene_type == "protein_coding"
rna.genes <- rna[genes,]

#! filtro zero and means
m <- assays(rna.genes)[["unstranded"]]
print("Input (dim): ")
print(dim(m))
threshold <- round(dim(m)[2]/2)
print(paste0("Threshold: ",threshold))
m <- m[rowSums(m == 0) <= threshold, ]
print(paste0("Rows After Zeros (dim): ",dim(m)[1]))
m <- m[rowMeans(m) >= 10, ]
print(paste0("Rows After means (dim): ",dim(m)[1]))
rna.genes <- rna.genes[rownames(m),]
dim(rna.genes)

pca.grupo(rna.genes,"outputs/plots/PCA-rna-postClean.png",'sample_type')

###############################################
#! Normalization
fac <- data.frame(tumor_stage=rna.genes$sample_type,
                  row.names=colnames(rna.genes))
noiseqData <- NOISeq::readData( assay(rna.genes), factors = fac)
mydata2corr1 = NOISeq::ARSyNseq(noiseqData, norm = "n",  logtransf = FALSE)
assay(rna.genes) <- exprs(mydata2corr1)



###############################################
#!  Plot PCA post Clean and Norm 
pca.grupo(rna.genes,"outputs/plots/PCA-rna-postNorm.png",'sample_type')



###########################################################
#! 04. Saving Data
RDS.dir <- "outputs/RDS"
dir.create(RDS.dir,recursive = TRUE)
saveRDS(rna.genes, file = paste0(RDS.dir,"/rna-Norm.rds"))
