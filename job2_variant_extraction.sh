#!/bin/bash
#SBATCH --time=01:59:59
#SBATCH --mem=64G
#SBATCH --job-name 2_Variant_extraction                                             		  # the name of this script
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.vanvugt-2@umcutrecht.nl

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "                                      Script to run the R-script script2_variant_extraction                                      "
echo "                                                      version 1.1 (20210709)                                                     "
echo ""
echo "* Written by      : Arjen Cupido"
echo "* Adapted by      : Marion van Vugt"
echo "* E-mail          : m.vanvugt-2@umcutrecht.nl"
echo "* Last update     : 2021-07-09"
echo "* Version         : Variant_extraction_1.1"
echo ""
echo "* Description     : This script runs the R-script script2_variant_extraction"
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo ""
date "+DATE: %a %d/%m/%Y%nTIME: %T"

echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo ""


# Firstly, retrieve rsids from the rbgen file by running the 'genoscript'. Please change the genoscript file for a different chromosome en output file
# Secondly, change the variant_extraction file for the R script which rewrites the rbgen file to a .csv file. This file can then be merged with the sample file and the phenotype data

SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

/hpc/dhl_ec/arjencupido/R-4.0.3/bin/Rscript ${SCRIPT}/script2_variant_extraction.r

#fi
