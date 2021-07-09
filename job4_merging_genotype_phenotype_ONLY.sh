#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --mem=64G
#SBATCH --job-name 4_Merge_ONLY                                            		  # the name of this script
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.vanvugt-2@umcutrecht.nl

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
OUTPUT=$1

/hpc/dhl_ec/arjencupido/R-4.0.3/bin/Rscript ${SCRIPT}/script3_merge_genotype_phenotype.r ${OUTPUT}
