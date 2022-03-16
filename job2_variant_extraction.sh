#!/bin/bash
#SBATCH --time=01:59:59
#SBATCH --mem=64G
#SBATCH --mail-type=ALL

# Firstly, retrieve rsids from the rbgen file by running the 'genoscript'. Please change the genoscript file for a different chromosome en output file
# Secondly, change the variant_extraction file for the R script which rewrites the rbgen file to a .csv file. This file can then be merged with the sample file and the phenotype data

/<USER>/R-4.0.3/bin/Rscript <USER>/UKB_scripts/script2_variant_extraction

#fi

