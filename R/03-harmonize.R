
library(stringr)
library(SummarizedExperiment)

rna.raw <- readRDS(file = "outputs/RDS/rna-raw.rds")
met.raw <- readRDS(file = "outputs/RDS/met-raw.rds")
miRs.raw <- readRDS(file = "outputs/RDS/miRs-raw.rds")

###########################################################
#! 01. Bulding miRNA summarizedExperiment

dim(miRs.raw)
cols <- grep("read_count", names(miRs.raw), value=T)
miRs.clean <- miRs.raw[, cols]
colnames(miRs.clean) <- cols %>% str_replace("^read_count_", "")
rownames(miRs.clean) <- miRs.raw$miRNA_ID

sampleid <- substring(colnames(miRs.clean), first=1, last=16)
typeid <- substring(colnames(miRs.clean), first=14, last=15)
submitter_id <- substring(colnames(miRs.clean), first=1, last=12)

colData <- DataFrame(sampleid=sampleid, typeid=typeid, 
                     submitter_id= submitter_id,
                     row.names=colnames(miRs.clean))

#! setear el rowData como: rowData=miRs.raw$miRNA_ID, 
miRs.se <- SummarizedExperiment(assays=list(counts=miRs.clean),
                     colData=colData)
# miRs.se[, miRs.se$typeid == "11"]
# table(miRs.se$typeid)

# View(as.data.frame(colData(rna.raw)))
# View(as.data.frame(colData(miRs.se)))
# View(as.data.frame(colData(met.raw)))


###########################################################
#! 02. Plot common samples

head(rna.raw$sample)
#! common.pats
D <- list('rna'=rna.raw$sample, 'miRs'=miRs.se$sampleid, 
          'meth'=met.raw$sample)
common.samples <- Reduce(intersect, D)
#! No hay duplicados en los pacientes
stopifnot(sum(duplicated(common.samples)) == 0)


library("ggvenn")
ggvenn(D,names(D),show_percentage=FALSE) + 
  ggtitle("Cases by Omic type")
plots.dir <- "outputs/plots"
dir.create(plots.dir,recursive = TRUE)
ggsave(paste0(plots.dir,"/venn-cases.png"))
#! hack removing this empty file
file.remove('Rplots.pdf')



###########################################################
#! 03. Hamonizing samples as common list

cols <- match(common.samples,rna.raw$sample)
#! Error si hay una muestra en RNA que no este en los common
stopifnot(sum(is.na(cols)) == 0)
#! Error si hay duplicados en las muestras
stopifnot(sum(duplicated(cols)) == 0)
rna.clean <- rna.raw[,cols]
cols <- rna.clean$definition %in% c("Primary solid Tumor","Solid Tissue Normal")
rna.clean <- rna.clean[,cols]
table(rna.clean$sample_type_id)

cols <- match(common.samples,miRs.se$sampleid)
#! Error si hay una muestra en RNA que no este en los common
stopifnot(sum(is.na(cols)) == 0)
#! Error si hay duplicados en las muestras
stopifnot(sum(duplicated(cols)) == 0)
miRs.clean <- miRs.se[,cols]
cols <- miRs.clean$typeid %in% c("01","11")
miRs.clean <- miRs.clean[,cols]
miRs.clean$type <- ""
miRs.clean[,miRs.clean$typeid == "01"]$type <- "Primary solid Tumor"
miRs.clean[,miRs.clean$typeid == "11"]$type <- "Solid Tissue Normal"
table(miRs.clean$type)


cols <- match(common.samples, met.raw$sample)
#! Error si hay una muestra en RNA que no este en los common
stopifnot(sum(is.na(cols)) == 0)
#! Error si hay duplicados en las muestras
stopifnot(sum(duplicated(cols)) == 0)
met.clean <- met.raw[,cols]
cols <- met.clean$definition %in% c("Primary solid Tumor","Solid Tissue Normal")
met.clean <- met.clean[,cols]
table(met.clean$sample_type_id)

# assays(rna.clean)$unstranded[1:5, 1:5]
# assays(rna.raw)$unstranded[1:5, 1:5]
# assays(miRs.se)$counts[1:5, 1:5]
# assays(met.clean)[[1]][1:5, 1:5]

D <- list('rna'=rna.clean[,rna.clean$sample_type_id == "01"]$sample, 
          'miRs'=miRs.clean[,miRs.clean$typeid == "01"]$sampleid,
          'met'=met.clean[,met.clean$sample_type_id == "01"]$sample)
common.samples <- Reduce(intersect, D)
#! Error si la interseccion de las muestras de cancer
stopifnot(length(common.samples) == 777)
D <- list('rna'=rna.clean[,rna.clean$sample_type_id == "11"]$sample, 
          'miRs'=miRs.clean[,miRs.clean$typeid == "11"]$sampleid,
          'met'=met.clean[,met.clean$sample_type_id == "11"]$sample)
common.samples <- Reduce(intersect, D)
#! Error si la interseccion de las muestras de normales
stopifnot(length(common.samples) == 76)


###########################################################
#! 04. Saving Data
RDS.dir <- "outputs/RDS"
dir.create(RDS.dir,recursive = TRUE)
saveRDS(rna.clean, file = paste0(RDS.dir,"/rna-cleanCols.rds"))
saveRDS(miRs.clean, file = paste0(RDS.dir,"/miRs-cleanCols.rds"))
saveRDS(met.clean, file = paste0(RDS.dir,"/met-cleanCols.rds"))
