#!/bin/bash
set -eo pipefail

echo test pipeline.. >> artifacts/test_artifact.log

export REF_FILE=${HOME}/data/hg38.fa

echo ref file: $REF_FILE
echo bed file: $BED_FILE
echo ref file: $REF_FILE >> artifacts/test_artifact.log
echo bed file: $BED_FILE >> artifacts/test_artifact.log

# run current pull request code

nextflow run ./main.nf \
       -profile conda \
       --cache ${HOME}/.conda/envs \
       --fastq_input ${REPO}/.github/data/fastqs \
       --host_reference ${REF_FILE} \
       --taxonomy_level 'S' \
       --host_name 'Homo sapiens' \
       --pathogen_name 'Severe acute respiratory syndrome-related coronavirus' \
       --outdir test_output

cp .nextflow.log artifacts/test.nextflow.log


rm -rf results && rm -rf work && rm -rf .nextflow*
