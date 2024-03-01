library(SummarizedExperiment)
require(TCGAbiolinks)
require(tictoc)

source("R/tools.R")

meth <- readRDS(file = "outputs/RDS/met-cleanCols.rds")
dim(meth)


###############################################
#! CLEAN
print(dim(meth))    #! 485577 x 853
meth <- subset(meth, subset = (rowSums(is.na(assay(meth))) == 0))
print(dim(meth))    #! 300636 x 853

###############################################
#! PLOTS
TCGAvisualize_meanMethylation( meth,
                               groupCol  = "sample_type", sort = "mean.desc", 
                               filename="outputs/plots/meth-meandesc.png")

table(meth$sample_type)
data <- TCGAanalyze_DMC(
  data = meth, 
  groupCol = "sample_type",
  group1 = "Primary Tumor",
  group2 = "Solid Tissue Normal",
  p.cut = 10^-5,
  diffmean.cut = 0.25,
  legend = "Sample Type",
  plot.filename = "outputs/plots/TumorVsNormal_metvolcano.png",
  save = FALSE
)

###########################################################
#! 04. Saving Data
RDS.dir <- "outputs/RDS"
dir.create(RDS.dir,recursive = TRUE)
saveRDS(meth, file = paste0(RDS.dir,"/meth-Norm.rds"))
