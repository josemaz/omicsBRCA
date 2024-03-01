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

#! RNAs
qry.rna <- GDCquery(project = proj.name,
                    data.category = "Transcriptome Profiling",
                    data.type = "Gene Expression Quantification",
                    workflow.type = "STAR - Counts")
GDCdownload(qry.rna)
rnas.raw <- GDCprepare(query = qry.rna, summarizedExperiment = TRUE)

setwd(root.path)

RDS.dir <- "outputs/RDS"
dir.create(RDS.dir,recursive = TRUE)
saveRDS(rnas.raw, file = paste0(RDS.dir,"/rna-raw.rds"))


