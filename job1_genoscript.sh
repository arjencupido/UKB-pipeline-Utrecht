#!/bin/bash
#SBATCH --time=03:59:59
#SBATCH --mem=64G
#SBATCH --job-name 1_Genoscript                                             		  # the name of this script
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.vanvugt-2@umcutrecht.nl

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "              Script to extract variants of choice and create the index files and list files for further processing              "
echo "                                                      version 1.1 (20210709)                                                     "
echo ""
echo "* Written by      : Arjen Cupido"
echo "* Adapted by      : Marion van Vugt"
echo "* E-mail          : m.vanvugt-2@umcutrecht.nl"
echo "* Last update     : 2021-07-09"
echo "* Version         : Genoscript_1.1"
echo ""
echo "* Description     : This script extracts variants of choice by reading in the names of the variants that are defined in the "
echo "                    indicated file. It also creates the index files and list files for further processing."
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
	echoerror "- Argument #1   -- Name of the file containing the variants including path, could be '/hpc/dhl_ec/mvanvugt/UKBB/variants.txt'"
  echoerror "- This file should contain two columns without a header: column 1 is the chromosome number and column 2 is the rsid."
  echoerror "- Argument #2   -- Path to where you want the output to be stored, could be '/hpc/dhl_ec/mvanvugt/UKBB'"
	echoerror ""
	echoerror "An example command would be: job1_genoscript.sh [arg1: /hpc/dhl_ec/mvanvugt/UKBB/variants.txt] [arg2: /hpc/dhl_ec/mvanvugt/UKBB]."
	echoerror "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  	# The wrong arguments are passed, so we'll exit the script now!
  	exit 1
}

if [ $# -lt 2]; then
  echo "Error, number of arguments found "$#"."
  script_arguments_error "You must supply [2] correct arguments when running this script"

else
  SCRIPT="${SLURM_SUBMIT_DIR}"
  INPUT="$1"
  OUTPUT="$2"

  if [[ ! -d ${OUTPUT}/temp/ ]]; then

    mkdir -v ${OUTPUT}/temp/

  fi

  TEMP="${OUTPUT}/temp"
  cd ${TEMP}

  echo "Script directory:___________________________________________ [ ${SCRIPT} ]"
  echo "Output directory:___________________________________________ [ ${OUTPUT} ]"
  echo ""
  echo "Input file with variants to be selected:____________________ [ ${INPUT} ]"

  for CHR in $(seq 1 22); do

    echo "Working on chromosome ${CHR} now"
    awk -v var=${CHR} '$1 == var {print $2}' ${INPUT} > ${TEMP}/chr${CHR}.txt
    bgenix -g  /hpc/ukbiobank/genetic_v3/ukb_imp_chr${CHR}_v3.bgen -incl-rsids ${TEMP}/chr${CHR}.txt > ${TEMP}/chr${CHR}.bgen

    # Create index files
    bgenix -g ${TEMP}/chr${CHR}.bgen -index -clobber

    # Create list files for use in R
    bgenix -g ${TEMP}/chr${CHR}.bgen -list > ${TEMP}/chr${CHR}.list

  done

fi

echo "Putting R to work"
/hpc/dhl_ec/arjencupido/R-4.0.3/bin/Rscript ${SCRIPT}/script1_variant_extraction.r ${OUTPUT} TRUE

# rm -r ${TEMP}
echo "Finished! Finito!"
