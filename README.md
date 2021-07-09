# Pipeline for extraction of data from the UK Biobank and for defining 300+ outcomes

Date: 16-MAR-2020

Last updated: 09-JUL-2021

**Introduction**
-----------------
This pipeline extracts phenotype data, transforms it to a certain extent, and combines it with genetic variants extracted from the genome-wide genetic data derived from the Axiom arrays.
The end result of this pipeline is a .rda file with phenotype and genetic data, which can be used for relatively small analyses such as Mendelian Randomization with a limited number of SNPs. The phenotype data - depending on the specific UK Biobank application this pipeline is used on - includes quality measures (Principal components), patient characteristics, biomarkers and specific clinical outcome as defined by the author, and by the CALIBER consortium.


**Prerequisites for pipeline to work:**
-------------------------------------
- Tested in R 4.0.3. Requires packages 'dplyr', 'data.table', 'stringr', 'RBGen'
- Unzip the CALIBER data
- One text file with all desired variants. No header, column 1 is the chromosome number and column 2 is the rsid

Buildup:
------------
There are three 4 different slurm jobs: jobs consists of 1 or 2 scripts either using slurm or R.
The idea to not merge this to 1 job is because sometimes:
- You quickly want additional SNPs (and don't waste your time with the lengthy process of defining phenotype)
- You quickly want an additional phenotype (avoiding the lengthy genotype scripts).  


**Job1: variant extraction and cleaning.**
- This job extracts SNPs from the BGEN files, writes to BGEN files and creates index and list files.
- Also calls script2_variant_extraction.r, read down below.

**~~Job2: Conversion of variants from BGEN to .csv~~**
- Job2 has become redundant because of addition to job1, but the script2_variant_extraction.r is still run
- This job converts the variants to .csv.
- NB SCRIPT DOES NOT WORK IF ONE RSID VARIANT IS DOUBLE IN THE VARIANT LIST! (e.g. a variant that has multiple different alleles)
- Originally written by Amy Mason (University of Cambridge)

**Job3: phenoscript_cleaning_merging**
- This job extracts the right datafields from the tab-delimited UKB files for both outcome and biomarkers.
	- NB The first part of this job is calling a script which cuts your desired phenotypes.
	- Read [here](https://github.com/CirculatoryHealth/UKBioPick) how it works.
- This job also comprises of 2 subsequent R scripts (script3_...).
	- The first R script script3_clean_data_create_outcome.r aggregates data on disease from the outcome fields to 1 variable. In essence these variables can be seen as lifetime incidence of disease X. Currently only for CAD: It extracts all dates a certain ICD/procedure code were assigned to a patient, with a dedicated column for the first occurrence of that code. It also renames all columns. See fields.csv for justification. For outcome justification: see excel file.
	- The second R script merges all phenotype data with genotype data.

**Job4: ONLY combining genotype and phenotype data**
- This job only runs the second R script from job 3. Handy if you just want to add a few SNPs to your dataset without rerunning the entire phenoscript file (which takes a while).

**Analysis tools**
-------------------------------
**Load dataset**
The R script 'source_base_dataset.r' can be sourced to load the data AND create an additional dataframe with information on all variants in your current dataset (e.g. alignment, allele frequencies). This is important for several downstream functions that rely on this list of variants to align your SNPs in your desired direction.

**Processing and analysis tools**
These are finished but need some cleaning up and will come very very soon.


**NB: PARTICIPANTS THAT HAVE WITHDRAWN CONSENT ARE NOT EXCLUDED IN THESE SCRIPTS. PLEASE EXCLUDE THESE PARTICIPANTS AFTER FINALIZING YOUR DATASET.**

**Future updates**
---------------------
- Integration of primary care data
- More outcomes
- Others
