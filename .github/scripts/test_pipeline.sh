#!/bin/bash
set -eo pipefail

export PATH=${HOME}/bin:/opt/miniconda3/bin:$PATH

echo test pipeline.. >> artifacts/test_artifact.log

export REF_FILE=${HOME}/data/chr22.fa
export KRAKEN2_BRACKEN_DB=${HOME}/data/kraken2_bracken_db

echo ref file: $REF_FILE
echo kraken2 db: $KRAKEN2_BRACKEN_DB
echo bracken db: $KRAKEN2_BRACKEN_DB

echo ref file: $REF_FILE >> artifacts/test_artifact.log
echo kraken2 db: $KRAKEN2_BRACKEN_DB >> artifacts/test_artifact.log
echo bracken db: $KRAKEN2_BRACKEN_DB >> artifacts/test_artifact.log

# run current pull request code

nextflow run ./main.nf \
       -profile conda \
       --cache ${HOME}/.conda/envs \
       --fastq_input ${REPO}/.github/data/fastqs \
       --host_reference ${REF_FILE} \
       --kraken2_db ${KRAKEN2_BRACKEN_DB} \
       --bracken_db ${KRAKEN2_BRACKEN_DB} \
       --read_length 151 \
       --taxonomy_level 'S' \
       --host_name 'Homo sapiens' \
       --pathogen_name 'Severe acute respiratory syndrome-related coronavirus' \
       --outdir test_output

cp .nextflow.log artifacts/test.nextflow.log


rm -rf results && rm -rf work && rm -rf .nextflow*
