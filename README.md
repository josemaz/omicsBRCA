# omicsBRCA

### Introduction

This repository contains code and supplementary materials for "Coordinated inflammation and immune
response transcriptional regulation in breast cancer molecular subtypes"

### Authors
Tadeo E. Velázquez-Caldelas, Jose Maria Zamora-Fuentes, Enrique Hernández-Lemus
### Intructions

1. Install R packages with script

```
$ Rscript R/InstallPackage.R
```

2. Uncompress extdata in root directory

```
unzip extdata-20240104.zip
mv extdata-20240104 extdata
```

3. You can use *Snakefile* allocated in root path

```
snakemake -c all all
```


### clean
```
snakemake -c all clean
```
