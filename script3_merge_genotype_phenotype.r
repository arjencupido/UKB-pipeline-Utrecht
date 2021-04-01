# R script for renaming biomarkers UKB
#libraries
library(dplyr)

#read file
setwd("<USER>/UKB_files/")

sample <- read.delim("/hpc/dhl_ec/data/ukbiobank/genetic_v3/ukb24711_imp_chr1_v3_s487371.sample",  sep = ' ', header=T)
sample <- sample[-1,] # Remove first column

chr1 <- read.csv("chr1.csv", header = T)
chr2 <- read.csv("chr2.csv", header = T) %>% subset(select=-X)
chr3 <- read.csv("chr3.csv", header = T) %>% subset(select=-X)
chr4 <- read.csv("chr4.csv", header = T) %>% subset(select=-X)
chr5 <- read.csv("chr5.csv", header = T) %>% subset(select=-X)
chr6 <- read.csv("chr6.csv", header = T) %>% subset(select=-X)
chr7 <- read.csv("chr7.csv", header = T) %>% subset(select=-X)
chr8 <- read.csv("chr8.csv", header = T) %>% subset(select=-X)
chr9 <- read.csv("chr9.csv", header = T) %>% subset(select=-X)
chr10 <- read.csv("chr10.csv", header = T) %>% subset(select=-X)
chr11 <- read.csv("chr11.csv", header = T) %>% subset(select=-X)
chr12<- read.csv("chr12.csv", header = T) %>% subset(select=-X)
chr13 <- read.csv("chr13.csv", header = T) %>% subset(select=-X)
chr14 <- read.csv("chr14.csv", header = T) %>% subset(select=-X)
chr15 <- read.csv("chr15.csv", header = T) %>% subset(select=-X)
chr16 <- read.csv("chr16.csv", header = T) %>% subset(select=-X)
chr17 <- read.csv("chr17.csv", header = T) %>% subset(select=-X)
chr18 <- read.csv("chr18.csv", header = T) %>% subset(select=-X)
chr19 <- read.csv("chr19.csv", header = T) %>% subset(select=-X)
chr20 <- read.csv("chr20.csv", header = T) %>% subset(select=-X)
chr21 <- read.csv("chr21.csv", header = T) %>% subset(select=-X)
chr22 <- read.csv("chr22.csv", header = T) %>% subset(select=-X)

load(file="<USER>/UKB_files/ICD_outcome_cleaned.rda")


tot <- cbind(sample, chr1, chr2, chr3, chr4, chr5, chr6, chr7, chr8, chr9, chr10, chr11, chr12, chr13, chr14, chr15, chr16, chr17, chr18, chr19, chr20, chr21, chr22) %>% inner_join(d, by = c('ID_1' = 'feid'), keep = T)

d <- tot

save(d, file="<USER>/UKB_files/FINAL_UKB_dataset.rda")
