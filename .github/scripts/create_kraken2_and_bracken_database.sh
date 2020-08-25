#!/bin/bash
set -eo pipefail

echo Create kraken2 db .. >> artifacts/test_artifact.log

export REPO=${PWD}

echo env name $(/opt/miniconda3/bin/conda info --envs | grep 'dehost-and-verify' | cut -d ' ' -f 1) >> artifacts/test_artifact.log

# environment name is suffixed by long alphanumeric string
# but it always starts with 'dehost-and-verify'. Use grep to find it.
source /opt/miniconda3/bin/activate $(conda info --envs | grep dehost-and-verify | cut -d ' ' -f 1)

KRAKEN2_DB_NAME=${HOME}/data/kraken2_bracken_db

mkdir $KRAKEN2_DB_NAME/taxonomy
rsync --no-motd rsync://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz $KRAKEN2_DB_NAME/taxonomy
tar -C $KRAKEN_DB_NAME/taxonomy -xvf $KRAKEN2_DB_NAME/taxonomy/taxdump.tar.gz
cp ${REPO}/.github/kraken2/nucl_gb_only_human_and_sars-cov-2.accession2taxid $KRAKEN2_DB_NAME/taxonomy
kraken2-build --db $KRAKEN2_DB_NAME --download-library human --no-mask
kraken2-build --db $KRAKEN2_DB_NAME --add-to-library ${REPO}/.github/data/kraken2/MN908947.3.kraken_annotated.fa
kraken2-build --db $KRAKEN2_DB_NAME --build --max-db-size 1000000000

bracken-build -d $KRAKEN2_DB_NAME -l 150

kraken2-build --db $KRAKEN2_DB_NAME --clean

