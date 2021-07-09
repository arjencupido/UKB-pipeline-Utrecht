#!/bin/bash
#SBATCH --time=03:59:59
#SBATCH --mem=64G
#SBATCH --job-name run_UKB_pipeline                                             		  # the name of this script
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
  echoerror "- Argument #1  --  Directory to the pipeline, could be '/hpc/dhl_ec/mvanvugt/Software/UKB-pipeline-Utrecht'"
  echoerror "- Argument #2  --  All/four  -- All indicates all scripts should be run, four means only job4"
  echoerror "- Argument #3  --  Input directory, could be '/hpc/dhl_ec/mvanvugt/test'"
  echoerror "- Argument #3  --  Output directory, could be '/hpc/dhl_ec/mvanvugt/test/results'"
	echoerror ""
	echoerror "An example command would be: run_UKB_pipeline.sh [arg1: /hpc/dhl_ec/mvanvugt/Software/UKB-pipeline-Utrecht] [arg2: All] [arg3: /hpc/dhl_ec/mvanvugt/test] [arg4: /hpc/dhl_ec/mvanvugt/test]."
	echoerror "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  	# The wrong arguments are passed, so we'll exit the script now!
  	exit 1
}

if [ $# -lt 4]; then
  echo "Error, number of arguments found "$#"."
  script_arguments_error "You must supply [4] correct arguments when running this script"

else

  SCRIPT="$1"
  TYPE="$2"
  INPUT="$3"
  OUTPUT="$4"

  echo ""
  echo "Script directory:____________________________________ [ ${SCRIPT} ]"
  echo "Input directory:_____________________________________ [ ${INPUT} ]"
  echo "Output directory:____________________________________ [ ${OUTPUT} ]"
  echo ""
  cd ${SCRIPT}

  if [[ ! -d ${SCRIPT}/logs/ ]]; then

    mkdir -v ${SCRIPT}/logs/

  fi


  if [[ ${TYPE} == "All" ]]; then

    echobold "Executing the full pipeline"
    echo ""
    echo "Starting with the genotypes"
    DEP1=$(sbatch --output ${SCRIPT}/logs/job1.log ${SCRIPT}/job1_genoscript.sh ${INPUT} ${OUTPUT} | sed 's/Submitted batch job //')

    echo "Continuing with the phenotypes"
    sbatch --output --dependency=afterok:${DEP1} ${SCRIPT}/logs/job3.log ${SCRIPT}/job3_phenoscript_cleaning_merging.sh ${OUTPUT} test


  elif [[ ${TYPE} == "four" ]]; then

    echobold "ONLY combining genotype and phenotype data"
    sbatch --output ${SCRIPT}/logs/job4.log ${SCRIPT}/job4_merging_genotype_phenotype_ONLY.sh ${OUTPUT}

  else

    echoerror "Type not recognized, please specify the second argument as All/four"

  fi

fi
