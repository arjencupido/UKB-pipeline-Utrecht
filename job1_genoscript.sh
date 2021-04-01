#!/bin/bash
#SBATCH --time=01:59:59
#SBATCH --mem=64G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<USER EMAIL>

################
# This script extracts variants of choice by reading in the names of the variants that are defined in the variants folder. 
# The script also creates the index files and list files for further processing
# Replace '<USER>' with your own folder
################



bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr1_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr1.txt > /<USER>/UKB_files/chr1.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr2_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr2.txt > /<USER>/UKB_files/chr2.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr3_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr3.txt > /<USER>/UKB_files/chr3.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr4_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr4.txt > /<USER>/UKB_files/chr4.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr5_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr5.txt > /<USER>/UKB_files/chr5.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr6_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr6.txt > /<USER>/UKB_files/chr6.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr7_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr7.txt > /<USER>/UKB_files/chr7.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr8_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr8.txt > /<USER>/UKB_files/chr8.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr9_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr9.txt > /<USER>/UKB_files/chr9.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr10_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr10.txt > /<USER>/UKB_files/chr10.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr11_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr11.txt > /<USER>/UKB_files/chr11.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr12_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr12.txt > /<USER>/UKB_files/chr12.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr13_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr13.txt > /<USER>/UKB_files/chr13.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr14_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr14.txt > /<USER>/UKB_files/chr14.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr15_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr15.txt > /<USER>/UKB_files/chr15.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr16_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr16.txt > /<USER>/UKB_files/chr16.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr17_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr17.txt > /<USER>/UKB_files/chr17.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr18_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr18.txt > /<USER>/UKB_files/chr18.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr19_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr19.txt > /<USER>/UKB_files/chr19.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr20_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr20.txt > /<USER>/UKB_files/chr20.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr21_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr21.txt > /<USER>/UKB_files/chr21.bgen
bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr22_v3.bgen -incl-rsids /<USER>/UKB_scripts/variants/chr22.txt > /<USER>/UKB_files/chr22.bgen


# Create index files
bgenix -g /<USER>/UKB_files/chr1.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr2.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr3.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr4.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr5.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr6.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr7.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr8.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr9.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr10.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr11.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr12.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr13.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr14.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr15.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr16.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr17.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr18.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr19.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr20.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr21.bgen -index -clobber
bgenix -g /<USER>/UKB_files/chr22.bgen -index -clobber

# Create list files for use in R
bgenix -g /<USER>/UKB_files/chr1.bgen -list > /<USER>/UKB_files/chr1.list
bgenix -g /<USER>/UKB_files/chr2.bgen -list > /<USER>/UKB_files/chr2.list
bgenix -g /<USER>/UKB_files/chr3.bgen -list > /<USER>/UKB_files/chr3.list
bgenix -g /<USER>/UKB_files/chr4.bgen -list > /<USER>/UKB_files/chr4.list
bgenix -g /<USER>/UKB_files/chr5.bgen -list > /<USER>/UKB_files/chr5.list
bgenix -g /<USER>/UKB_files/chr6.bgen -list > /<USER>/UKB_files/chr6.list
bgenix -g /<USER>/UKB_files/chr7.bgen -list > /<USER>/UKB_files/chr7.list
bgenix -g /<USER>/UKB_files/chr8.bgen -list > /<USER>/UKB_files/chr8.list
bgenix -g /<USER>/UKB_files/chr9.bgen -list > /<USER>/UKB_files/chr9.list
bgenix -g /<USER>/UKB_files/chr10.bgen -list > /<USER>/UKB_files/chr10.list
bgenix -g /<USER>/UKB_files/chr11.bgen -list > /<USER>/UKB_files/chr11.list
bgenix -g /<USER>/UKB_files/chr12.bgen -list > /<USER>/UKB_files/chr12.list
bgenix -g /<USER>/UKB_files/chr13.bgen -list > /<USER>/UKB_files/chr13.list
bgenix -g /<USER>/UKB_files/chr14.bgen -list > /<USER>/UKB_files/chr14.list
bgenix -g /<USER>/UKB_files/chr15.bgen -list > /<USER>/UKB_files/chr15.list
bgenix -g /<USER>/UKB_files/chr16.bgen -list > /<USER>/UKB_files/chr16.list
bgenix -g /<USER>/UKB_files/chr17.bgen -list > /<USER>/UKB_files/chr17.list
bgenix -g /<USER>/UKB_files/chr18.bgen -list > /<USER>/UKB_files/chr18.list
bgenix -g /<USER>/UKB_files/chr19.bgen -list > /<USER>/UKB_files/chr19.list
bgenix -g /<USER>/UKB_files/chr20.bgen -list > /<USER>/UKB_files/chr20.list
bgenix -g /<USER>/UKB_files/chr21.bgen -list > /<USER>/UKB_files/chr21.list
bgenix -g /<USER>/UKB_files/chr22.bgen -list > /<USER>/UKB_files/chr22.list