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

chrs <- list()
tot <- sample
for (i in 1:22) {

  if (i == 1) {
    chrs[[i]] <- read.csv(paste0("chr", i, ".csv"), header = T)
  } else {

    chrs[[i]] <- read.csv(paste0("chr", i, ".csv"), header = T) %>% subset(select=-X)

  }
  if (nrow(chrs[[i]]) == nrow(sample)) {

    tot <- cbind(tot, chrs[[i]])

  } else {

    cat(paste0("\nALERT! The file for chromosome ", i, " has a different number of rows: "))
    cat(paste0(nrow(chrs[[i]]), " in stead of ", nrow(sample), "\n"))

  }

}

load(file = paste0(input, "/ICD_outcome_cleaned.rda"))


tot <- tot %>% inner_join(d, by = c('ID_1' = 'feid'), keep = T)

d <- tot %>% select(!starts_with("f."))

save(tot, file = paste0(input, "/FINAL_UKB_dataset.rda"))
save(d, file = paste0(input, "/FINAL_UKB_dataset_named.rda"))
write.table(d, "paste0(input, "/FINAL_UKB_dataset_named.tsv"), row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")
