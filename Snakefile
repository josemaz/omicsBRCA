
rule all:
	input:
		"outputs/RDS/TCGA_BRCA-rna-raw.rds",
		"outputs/tables/BRCA-clinical.tsv",

rule download:
	output:
		"outputs/RDS/TCGA_BRCA-rna-raw.rds",
	shell: "Rscript R/01-download.R"

rule clinical:
	input:
		"outputs/RDS/TCGA_BRCA-rna-raw.rds",
	output:
		"outputs/tables/BRCA-clinical.tsv",
	shell:
		"Rscript R/02-clinical.R"

