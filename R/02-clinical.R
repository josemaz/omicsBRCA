suppressPackageStartupMessages({
  library(SummarizedExperiment)
  library(tidyr)
})

#! Loading data
rna.raw <- readRDS(file = "outputs/RDS/TCGA_BRCA-rna-raw.rds")

##############################################################
#! Clinical analysis

#! Selecting
df <- as.data.frame(colData(rna.raw))
cols <- c("age_at_index","race","ethnicity","gender","ajcc_pathologic_stage")
df1 <- df[cols]

#! Exploring
str(df1)
summary(df1$age_at_index)
# table(df1$race)
# table(df1$gender)
table(df1$ajcc_pathologic_stage)

#! Cleaning
df2 <-  df1
nrow(df2) # 1231
df2 <- drop_na(df2) 
nrow(df2) # 1218
df2 <- subset(df2, race != "not reported") 
nrow(df2) # 1124
df2 <- subset(df2, ethnicity != "not reported") 
nrow(df2) # 1016
df2 <- subset(df2, ajcc_pathologic_stage != "Stage X") 
nrow(df2) # 1007
# View(df2)
table(df2$race)
table(df2$gender)
#| quitar hombres
table(df2$ethnicity)

#! Transform stage
df2$stage <- ""
grps <- c("Stage I","Stage IA","Stage IB")
df2[df2$ajcc_pathologic_stage %in% grps,]$stage <- "Stage_I"
grps <- c("Stage II","Stage IIA","Stage IIB")
df2[df2$ajcc_pathologic_stage %in% grps,]$stage <- "Stage_II"
grps <- c("Stage III","Stage IIIA","Stage IIIB","Stage IIIC")
df2[df2$ajcc_pathologic_stage %in% grps,]$stage <- "Stage_III"
grps <- c("Stage IV")
df2[df2$ajcc_pathologic_stage %in% grps,]$stage <- "Stage_IV"
table(df2$ajcc_pathologic_stage)
table(df2$stage)
#| quitar el normal-like

#! Outputs
tables.dir <- "outputs/tables"
dir.create(tables.dir,recursive = TRUE)
write.table(df2, file=paste0(tables.dir,'/BRCA-clinical.tsv'),

                        quote=FALSE, sep='\t', col.names = NA)
# plots.dir <- "outputs/plots"
# dir.create(plots.dir,recursive = TRUE)
# png(paste0(plots.dir,'/BRCA-histogram-age.png'))
# hist(df1$age_at_index)
# dev.off()