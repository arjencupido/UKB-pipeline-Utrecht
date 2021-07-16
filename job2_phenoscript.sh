#!/bin/bash
#SBATCH --time=14:59:59
#SBATCH --mem=64G
#SBATCH --job-name 2_Phenoscript                                             		  # the name of this script
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.vanvugt-2@umcutrecht.nl

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "                                        Script to extract phenotype data from UKB tab file                                       "
echo "                                                      version 1.1 (20210710)                                                     "
echo ""
echo "* Written by      : Arjen Cupido"
echo "* Adapted by      : Marion van Vugt"
echo "* E-mail          : m.vanvugt-2@umcutrecht.nl"
echo "* Last update     : 2021-07-10"
echo "* Version         : Phenoscript_1.1"
echo ""
echo "* Description     : This script extracts phenotype data from UKB tab file."
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo ""
date "+DATE: %a %d/%m/%Y%nTIME: %T"

echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo ""

NONE='\033[00m'
BOLD='\033[1m'
RED='\033[01;31m'


function echobold {                       # 'echobold' is the function name
    echo -e "${BOLD}${1}${NONE}"          # this is whatever the function needs to execute, note ${1} is the text for echo
}

function echoerror {
    echo -e "${RED}${1}${NONE}"
}

script_copyright_message() {
	echo ""
	THISYEAR=$(date +'%Y')
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "+ The MIT License (MIT)                                                                                 +"
	echo "+ Copyright (c) 1979-${THISYEAR} Marion van Vugt                                                        +"
	echo "+                                                                                                       +"
	echo "+ Permission is hereby granted, free of charge, to any person obtaining a copy of this software and     +"
	echo "+ associated documentation files (the \"Software\"), to deal in the Software without restriction,       +"
	echo "+ including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, +"
	echo "+ and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, +"
	echo "+ subject to the following conditions:                                                                  +"
	echo "+                                                                                                       +"
	echo "+ The above copyright notice and this permission notice shall be included in all copies or substantial  +"
	echo "+ portions of the Software.                                                                             +"
	echo "+                                                                                                       +"
	echo "+ THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT   +"
	echo "+ NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                +"
	echo "+ NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES  +"
	echo "+ OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN   +"
	echo "+ CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                            +"
	echo "+                                                                                                       +"
	echo "+ Reference: http://opensource.org.                                                                     +"
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
}

script_arguments_error() {
	echoerror "$1" # ERROR MESSAGE
	echoerror "- Argument #1   -- Path to where you want the output to be stored, could be '/hpc/dhl_ec/mvanvugt/UKBB'"
  echoerror "- Argument #2   -- Prefix of your output files, could be 'Project1'"
  echoerror "- Argument #3   -- OPTIONAL -- Path and name to/of the file with phenotypes to be selected from the UKB phenotype file, could be '/hpc/dhl_ec/mvanvugt/UKBB/phenotypes.tsv'"
  echoerror "- Argument #4   -- OPTIONAL -- Path and name to/of the UKB phenotype file, could be '/hpc/dhl_ec/data/ukbiobank/phenotypic/ukb44641.tab'"
	echoerror ""
  echoerror "An example command would be: job2_phenoscript.sh [arg1: /hpc/dhl_ec/mvanvugt/UKBB] [arg2: Project1] [arg3: /hpc/dhl_ec/mvanvugt/UKBB/phenotypes.tsv] [arg4: /hpc/dhl_ec/data/ukbiobank/phenotypic/ukb44641.tab]."
  echoerror ""
  echoerror "For argument #3 and #4, defaults are stated, namely:"
  echoerror "Argument #3 default = Phenotypes.tsv (present in the folder of the scripts)"
  echoerror "Argument #4 default = /hpc/dhl_ec/data/ukbiobank/phenotypic/ukb44641.tab"
  echoerror "If you want to change the UK Biobank phenotype file, but not the default of the selection file, use the following command:"
	echoerror "job2_phenoscript.sh [arg1: /hpc/dhl_ec/mvanvugt/UKBB] [arg2: Project1] [arg3: ""] [arg4: /hpc/dhl_ec/data/ukbiobank/phenotypic/ukb44641.tab]."
	echoerror "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  	# The wrong arguments are passed, so we'll exit the script now!
  	exit 1
}

if [ $# -lt 2]; then
  echo "Error, number of arguments found "$#"."
  script_arguments_error "You must supply [2] correct arguments when running this script"

else

  OUTPUT=$1
  NAME=$2
  UKB=${4:-/hpc/dhl_ec/data/ukbiobank/phenotypic/ukb44641.tab}
  SCRIPT="${SLURM_SUBMIT_DIR}"
  PHENO="${3:-$( echo ${SCRIPT}/Phenotypes.tsv )}"

  if [[ ! -d ${SCRIPT}/logs/ ]]; then

    mkdir -v ${SCRIPT}/logs/

  fi

  echo "Script directory:________________________________________________ [ ${SCRIPT} ]"
  echo "Output directory:________________________________________________ [ ${OUTPUT} ]"
  echo ""
  echo "Phenotype file of the UKB:_______________________________________ [ ${UKB} ]"
  echo "File with phenotypes to be selected from UKB:____________________ [ ${PHENO} ]"
  echo "Prefix of the output file with selected phenotypes:______________ [ ${NAME} ]"

  # Cut ICD and other outcome data, please define the place where your UKB data is.
  DEP1=$(sbatch /hpc/dhl_ec/mvanvugt/scripts/ukb_pheno_v1.sh ${UKB} ${PHENO} ${OUTPUT} ${NAME} | sed 's/Submitted batch job //')

  # Submit R-wrapper for cleaning and merging
  sbatch --output ${SCRIPT}/logs/job3.log --dependency=afterok:${DEP1} ${SCRIPT}/job3_cleaning_merging.sh ${OUTPUT} ${NAME} ${PHENO} ${UKB}

fi

echo "Finished! Finito!"
