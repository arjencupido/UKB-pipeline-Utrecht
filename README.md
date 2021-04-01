# UKB-pipeline
Pipeline for extraction of UK Biobank data and analysis tools in R

Date: 16-MAR-2020

Last updated: 01-APR-2021

Email: arjen.cupido@gmail.com

**Introduction**
-----------------
This pipeline extracts phenotype data and combines it with variants extracted from the genotype data.
The end result of this pipeline is a .rda file with phenotype and genotype data. The phenotype data will include - among others - quality measures (Principal components), patient characteristics, biomarkers and clinical outcome as defined by the author, and by the CALIBER consortium


**Prerequisites for pipeline to work:**
-------------------------------------
- Create a folder 'UKB_files' and a folder 'UKB_scripts' in your folder of choice
- Create a folder 'variants' and a folder 'CALIBER' in the UKB_scripts folder.
- copy all scripts and the fields.csv file to the folder UKB_scripts. Copy the CALIBER data to CALIBER folder. Copy text files with the desired variant rsids to the variants folder. 
- check each script for the paths, search for the word USER (and the brackets around it), and replace it with your folder of choice

Buildup:
------------
There are three 4 different slurm jobs: jobs consists of 1 or 2 scripts either using slurm or R.
The idea to not merge this to 1 job is because sometimes:
- You quickly want additional SNPs (and don't waste your time with the lengthy process of defining phenotype)
- You quickly want an additional phenotype (avoiding lengthy genotype scripts).  

**Job1: variant extraction and cleaning. **
- this job extracts SNPs from the BGEN files, writes to BGEN files and creates index and list files. Files are written to UKB_files folder.
- please change every chrX.txt files in the variants folder to extract the SNPs of your choice.
		- I Believe this can be updated by just using one chrALL.txt file (so run each BGENIX script with just one chr.txt file instead of the current 22). Not tested yet.

**Job2: Conversion of variants from BGEN to .csv**
- This job converts the variants to .csv. 
- calls script2_variant_extraction.r.
- Courtesy to Amy Mason from University of Cambridge
- NB SCRIPT DOES NOT WORK IF ONE RSID VARIANT IS DOUBLE IN THE VARIANT LIST! (e.g. a variant that has multiple different alleles)

**Job3: phenoscript_cleaning_merging**
- This job extracts the right datafields from the tab-delimited UKB files for both outcome and biomarkers
- This job also comprises of 2 subsequent R scripts (script3_...).
- The first R script R_aggregate_ICD.R aggregates data on disease from the outcome fields to 1 variable. In essence these variables can be seen as lifetime incidence of disease X. It also renames columns. Outcome justification will come later
- The second R script merges all phenotype data with genotype data. 


**Job4: ONLY combining genotype and phenotype data**
- This job only runs the second R script from job 3. Handy if you just want to add a few SNPs to your dataset.

**Analysis tools**
-------------------------------
**Load dataset**
The R script 'source_base_dataset.r' can be sourced to load the data AND create an additional dataframe with information on all variants in your current dataset (e.g. alignment, allele frequencies). This is important for several downstream functions that rely on this list of variants to align your SNPs in your desired direction. 

**Processing and analysis tools**
These are finished but need some cleaning up and will come very very soon. 


**NB: PARTICIPANTS THAT HAVE WITHDRAWN CONSENT ARE NOT EXCLUDED IN THESE SCRIPTS. PLEASE EXCLUDE THESE PARTICIPANTS AFTER FINALIZING YOUR DATASET.**


