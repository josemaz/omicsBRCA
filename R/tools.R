pca.grupo <- function(dat, fout = NULL, grp = 'tipo'){
  d2 <- data.frame(grupos = colData(dat)[,grp])
  rownames(d2) <- colnames(dat)
  mydat = NOISeq::readData( assay(dat) , factors = d2)
  # myPCA = dat(mydat, type = "PCA", norm=TRUE)
  myPCA = dat(mydat, type = "PCA", logtransf = F)
# fout <- "outputs/plots/PCA-pre.png"
  print(paste0("Writing in: ",fout))
  png(fout,type="cairo")
  explo.plot(myPCA, factor = "grupos", plottype = "scores")
  dev.off()
}
