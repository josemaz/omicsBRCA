library(NOISeq)
library(SummarizedExperiment)

pca.grupo <- function(dat, fout = NULL, grp = 'tipo'){
  d2 <- data.frame(grupos = colData(dat)[,grp])
  rownames(d2) <- colnames(miRs)
  mydat = NOISeq::readData( assay(miRs) , factors = d2)
  # myPCA = dat(mydat, type = "PCA", norm=TRUE)
  myPCA = dat(mydat, type = "PCA", logtransf = F)
# fout <- "outputs/plots/PCA-pre.png"
  print(paste0("Writing in: ",fout))
  png(fout,type="cairo")
  explo.plot(myPCA, factor = "grupos", plottype = "scores")
  dev.off()
}

miRs <- readRDS(file = "outputs/RDS/miRs-cleanCols.rds")
# table(miRs.cleanCols$type)
# rownames(miRs.cleanCols)

###############################################
#! Plot PCA pre-clean 
pca.grupo(miRs,"outputs/plots/PCA-miRs-pre.png",'type')

###############################################
#! Clean miRNAs
m <- assay(miRs)
print("Input (dim): ")
print(dim(m))
threshold <- round(dim(miRs)[2]/2)
print(paste0("Threshold: ",threshold))
m <- m[rowSums(m == 0) <= threshold, ]
print(paste0("Rows After Zeros (dim): ",dim(m)[1]))
m <- m[rowMeans(m) >= 10, ]
print(paste0("Rows After means (dim): ",dim(m)[1]))
miRs <- miRs[rownames(miRs) %in% rownames(m),]


###############################################
#! Here miRNAs can be annotated


###############################################
#! Normalization
fac <- data.frame(tumor_stage=miRs$type, 
                  row.names=colnames(miRs))
noiseqData <- NOISeq::readData( assay(miRs), factors = fac)
mydata2corr1 = NOISeq::ARSyNseq(noiseqData, norm = "n",  logtransf = FALSE)
assay(miRs) <- exprs(mydata2corr1)


###############################################
#!  Plot PCA post Clean and Norm 
pca.grupo(miRs,"outputs/plots/PCA-miRs-post.png",'type')


###########################################################
#! 04. Saving Data

RDS.dir <- "outputs/RDS"
dir.create(RDS.dir,recursive = TRUE)
saveRDS(miRs, file = paste0(RDS.dir,"/miRs-Norm.rds"))
