# R script for renaming biomarkers UKB

# Arguments expected:
#         #1 -- Directory to the chromosome csv files and output directory

args = commandArgs(trailingOnly = TRUE)
input = args[1]

#libraries
library(dplyr)

#read file
setwd(input)

sample <- read.delim("/hpc/dhl_ec/data/ukbiobank/genetic_v3/ukb24711_imp_chr1_v3_s487371.sample",  sep = ' ', header=T)
sample <- sample[-1,] # Remove first column

chr1 <- read.csv("chr1.csv", header = T)

chrs <- list()
for (i in 2:22) {

  chrs[[i]] <- read.csv(paste0("chr", i, ".csv"), header = T) %>% subset(select=-X))

}

load(file = paste0(input, "/ICD_outcome_cleaned.rda"))


tot <- cbind(sample, chr1, chrs[[2]], chrs[[3]], chrs[[4]], chrs[[5]], chrs[[6]], chrs[[7]], chrs[[8]], chrs[[9]], chrs[[10]], chrs[[11]], chrs[[12]], chrs[[13]], chrs[[14]], chrs[[15]], chrs[[16]], chrs[[17]], chrs[[18]], chrs[[19]], chrs[[20]], chrs[[21]], chrs[[22]]) %>% inner_join(d, by = c('ID_1' = 'feid'), keep = T)

d <- tot

save(d, file = paste0(input, "/FINAL_UKB_dataset.rda"))
