# omicsBRCA

### Introduction

This repository contains code and supplementary materials for paper XXXXXXX

### Authors
Enrique Hernandez Lemus, Jose Maria Zamora-Fuentes, Jesus Espinal-Enriquez

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
