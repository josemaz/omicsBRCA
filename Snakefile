
rule all:
	input:
		"outputs/RDS/rna-raw.rds",
        "outputs/RDS/miRs-raw.rds",
        "outputs/RDS/met-raw.rds",
		"outputs/tables/BRCA-clinical.tsv",
		"outputs/RDS/rna-cleanCols.rds",
		"outputs/RDS/miRs-cleanCols.rds",
		"outputs/RDS/met-cleanCols.rds",
		"outputs/plots/venn-cases.png",
		"outputs/RDS/miRs-Norm.rds",
		"outputs/plots/PCA-miRs-pre.png",
		"outputs/plots/PCA-miRs-post.png",
		"outputs/plots/PCA-rna-preClean.png",
		"outputs/plots/PCA-rna-postClean.png",
		"outputs/plots/PCA-rna-postNorm.png",
		"outputs/RDS/rna-Norm.rds",
		"outputs/plots/meth-meandesc.png",
		"outputs/plots/TumorVsNormal_metvolcano.png",
		"outputs/RDS/meth-Norm.rds",
		"outputs/tables/rnas-norm.tsv",
		"outputs/tables/miRs-norm.tsv",
		"outputs/tables/meth-norm.tsv",

rule download_rna:
	output:
		"outputs/RDS/rna-raw.rds",
	shell: "Rscript R/01-download-rna.R"

rule download_miRs:
    output:
        "outputs/RDS/miRs-raw.rds",
    shell: "Rscript R/01-download-miRs.R"

rule download_mets:
    output:
        "outputs/RDS/met-raw.rds",
    shell: "Rscript R/01-download-mets.R"

rule clinical:
	input:
		"outputs/RDS/rna-raw.rds",
	output:
		"outputs/tables/BRCA-clinical.tsv",
	shell:
		"Rscript R/02-clinical.R"

rule harmonize:
	input:
		"outputs/RDS/rna-raw.rds",
		"outputs/RDS/miRs-raw.rds",
		"outputs/RDS/met-raw.rds",
	output:
		"outputs/RDS/rna-cleanCols.rds",
		"outputs/RDS/miRs-cleanCols.rds",
		"outputs/RDS/met-cleanCols.rds",
		"outputs/plots/venn-cases.png"
	shell:
		"Rscript R/03-harmonize.R"

rule norm_miRs:
	input:
		"outputs/RDS/miRs-cleanCols.rds",
	output:
		"outputs/RDS/miRs-Norm.rds",
		"outputs/plots/PCA-miRs-pre.png",
		"outputs/plots/PCA-miRs-post.png"
	shell:
		"Rscript R/04-clean-miRs.R"

rule norm_rnas:
	input:
		"outputs/RDS/rna-cleanCols.rds",
	output:
		"outputs/plots/PCA-rna-preClean.png",
		"outputs/plots/PCA-rna-postClean.png",
		"outputs/plots/PCA-rna-postNorm.png",
		"outputs/RDS/rna-Norm.rds",
	shell:
		"Rscript R/04-clean-rna.R"

rule norm_meths:
	input:
		"outputs/RDS/met-cleanCols.rds",
	output:
		"outputs/plots/meth-meandesc.png",
		"outputs/plots/TumorVsNormal_metvolcano.png",
		"outputs/RDS/meth-Norm.rds",
	shell:
		"Rscript R/04-clean-meth.R"

rule WriteTables:
	input:
		"outputs/RDS/rna-Norm.rds",
		"outputs/RDS/miRs-Norm.rds",
		"outputs/RDS/meth-Norm.rds"
	output:
		"outputs/tables/rnas-norm.tsv",
		"outputs/tables/miRs-norm.tsv",
		"outputs/tables/meth-norm.tsv",
	shell:
		"Rscript R/05-writeTables.R"

rule cleanProj:
	shell:
		"rm -rf outputs/plots outputs/RDS outputs/tables"

