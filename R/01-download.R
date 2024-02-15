suppressPackageStartupMessages({
  library(TCGAbiolinks)
  library(crayon)
})

proj.name <- "TCGA-BRCA"

RDS.dir <- "outputs/RDS"
dir.create(RDS.dir,recursive = TRUE)

cat(blue("0.5 Download Data"),"\n")
getwd()
gdc.dir <- "outputs/GDC"
dir.create(gdc.dir,recursive = TRUE)
setwd(gdc.dir)
query <- GDCquery(project = proj.name,
                  data.category = "Transcriptome Profiling",
                  data.type = "Gene Expression Quantification",
                  workflow.type = "STAR - Counts")
GDCdownload(query)
#! gene annotation GRCh38.p13
rna.raw <- GDCprepare(query)
setwd("../../")
cat(blue("0.5 Saving RDS"),"\n")
saveRDS(rna.raw, file = paste0(RDS.dir,"/TCGA_BRCA-rna-raw.rds"))