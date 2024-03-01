#! Catch error: ehub <- ExperimentHub::ExperimentHub()
#! Install from github: remotes::install_github("Bioconductor/BiocFileCache")

library(TCGAbiolinks)

#! Download omics

proj.name <- "TCGA-BRCA"

root.path <- getwd()
print(root.path)

# gdc.dir <- "/mnt/scratch/TCGA-data"
gdc.dir <- "outputs/TCGA-data"
dir.create(gdc.dir,recursive = TRUE)
setwd(gdc.dir)

#! miRNAs
qry.mir <- GDCquery(project = proj.name,
                    data.category = "Transcriptome Profiling",
                    data.type = "miRNA Expression Quantification",
                    workflow.type = "BCGSC miRNA Profiling")
GDCdownload(qry.mir)
miRs.raw <- GDCprepare(query = qry.mir, summarizedExperiment = FALSE)


setwd(root.path)

RDS.dir <- "outputs/RDS"
dir.create(RDS.dir,recursive = TRUE)
saveRDS(miRs.raw, file = paste0(RDS.dir,"/miRs-raw.rds"))
