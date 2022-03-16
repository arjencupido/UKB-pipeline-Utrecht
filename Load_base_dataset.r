# BASE DATASET AND FUNCTION SCRIPT
# Arjen Cupido
# Creation date: 24/08/2020
# Last updated: 17/02/2021
############################
message('Load packages...')
# Load packages
library(dplyr)


# Extra functions and Ggplot theme

#source(file = "<USER>/scripts/function_script.R") , future update

`%notin%` <- Negate(`%in%`)

# Load  data, subtract all partipicants who withdrewn consent. 
message("Load data...")
load(file = "<USER>/UKB_files/FINAL_UKB_dataset.rda")


# Read details on all variants extracted from the .list file from BGEN
message("Load metadata on genetic variants...")

UKBvariants <- list()

for (i in 1:22) {

  setwd('/hpc/dhl_ec/arjencupido/UKB_files/') # Where the list files are

  x<- read.delim(file = paste0("chr", i, ".list"), header = T, sep = "\t", comment.char="#", stringsAsFactors = F, colClasses = "character")

  UKBann[[i]] <- x

}

datasetvariants <- do.call(rbind, UKBvariants) # List with variants extracted, and their allelic annotation

message("Done. dataframe 'd' holds all data from all participants who have given consent and for whom genetic data is available.")
message( "Dataframe 'datasetvariants' holds information on the genetic variants in the dataset.")
message("Please note the extra functions that have been written. Use at own risk")
message("For more information on how variables are being defined, please refer to excel file")
##############################
##############################

