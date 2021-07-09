#########################
# This script reads BGEN files and formats it to csv files for easy use in R
# Courtesy to Amy Mason from Cambridge.

# The following arguments are expected:
# Argument #1 -- Directory to the bgen files
# Argument #2 -- Whether all chromosomes should be done (TRUE) or the number of the chromosome to be analyzed

# This script can take a while to run.
#########################

args = commandArgs(trailingOnly = TRUE)
input = args[1]
type = args[2]

setwd(input)
require(rbgen)
require(dplyr)

chromosomevector <- c("chr1", "chr2", "chr3", "chr4", "chr5", "chr6",  "chr7", "chr8", "chr9", "chr10", "chr11", "chr12", "chr13", "chr14", "chr15", "chr16", "chr17", "chr18", "chr19", "chr20", "chr21", "chr22")

chromosomelist <- list()

if (isTRUE(type)) {

  ###################################################
  # per chromosome
  # NB SCRIPT DOES NOT WORK IF ONE RSID VARIANT IS DOUBLE IN THE VARIANT LIST! (e.g. a variant that has multiple different alleles)


  # loop
  for(i in 1:length(chromosomevector)){

    print(paste0(chromosomevector[i]))

    variants = read.delim(paste0(input, chromosomevector[i], ".list"), stringsAsFactors=FALSE, header=TRUE, skip=1, comment.char="#")
    varvec <- c(as.character(variants$rsid))

    data = bgen.load(paste0(chromosomevector[i],".bgen"), rsids = varvec)
    data.summ = apply(data$data, 1, function(data) { return(data[,1]*0 + data[,2]*1 + data[,3]*2) })

    write.csv(data.summ, paste0(chromosomevector[i],".csv"))
  } # End iteration chromosomes

} else {

  ###################################################
  # For individual analyses
  chromosomelist[paste(chromosomevector[i])] <- data.summ
  chromosomedataframe <- data.frame()

  for (i in 1:22) {
    chromosomedataframe <- cbind(chromosomedataframe, chromosomelist[[i]])
  }

  write.csv(chromosomedataframe, "total_variants.csv")

  # End

  variants = read.delim(paste0(input, "/chr", type, ".list"), stringsAsFactors=FALSE, header=TRUE, skip=1, comment.char="#")
  varvec <- c(as.character(variants2$rsid))
  varvec2 <- c(as.character(variants$rsid[3:96]))
  varvec3 <- c(as.character(variants$rsid[61:96]))
  data = bgen.load(paste0("chr", type, "".bgen"), rsids = varvec)
  data.summ = apply(data$data, 1, function(data) { return(data[,1]*0 + data[,2]*1 + data[,3]*2) })

  write.csv(data.summ, paste0("chr", type, ".csv"))

} # End checking whether all or one chromosome should be analyzed
