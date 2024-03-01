# omicsBRCA

### Introduction

This repository contains code and supplementary materials for "Coordinated inflammation and immune
response transcriptional regulation in breast cancer molecular subtypes"

### Authors
Tadeo E. Velázquez-Caldelas, Jose Maria Zamora-Fuentes, Enrique Hernández-Lemus

### Important Notes

- Minimum requeriments in hardware
	- This pipeline requires about 40 Gb in space on disk
	- 63 GB RAM
	- 16 Cores CPU
- About 3 hours of computing time in a server with 32 cores and 64Gb RAM. 

### Instructions

1. Install R packages with script

```
$ Rscript R/InstallPackage.R
```

3. You can use *Snakefile* allocated in root path

```
snakemake -c all all
# /usr/bin/time -o  tiempo-pipeline.txt snakemake -j 1 all  &> salida &
```


### Clean Project
```
snakemake -c all cleanAll
```
