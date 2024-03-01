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

#! Methylation
qry.met <- GDCquery(
  project = proj.name,
  data.category = "DNA Methylation",
  platform = c("Illumina Human Methylation 450"),
  data.type = "Methylation Beta Value"
)
GDCdownload(qry.met)
met.raw <- GDCprepare(query = qry.met)

setwd(root.path)

RDS.dir <- "outputs/RDS"
dir.create(RDS.dir,recursive = TRUE)
saveRDS(met.raw, file = paste0(RDS.dir,"/met-raw.rds"))
