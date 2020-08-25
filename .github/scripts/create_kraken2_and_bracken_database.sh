#!/bin/bash
set -eo pipefail

echo Create kraken2 db .. >> artifacts/test_artifact.log

REPO=${PWD}

echo env name $(conda info --envs | grep 'dehost-and-verify' | cut -d ' ' -f 1) >> artifacts/test_artifact.log

# environment name is suffixed by long alphanumeric string
# but it always starts with 'dehost-and-verify'. Use grep to find it.
source /opt/miniconda3/bin/activate $(conda info --envs | grep dehost-and-verify | cut -d ' ' -f 1)

KRAKEN2_DB_NAME=${HOME}/data/kraken2_bracken_db
echo KRAKEN2_DB_NAME=${KRAKEN2_DB_NAME} >> ${REPO}/artifacts/test_artifact.log
mkdir -p $KRAKEN2_DB_NAME/taxonomy

rsync --no-motd rsync://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz $KRAKEN2_DB_NAME/taxonomy
tar -C $KRAKEN2_DB_NAME/taxonomy -xvf $KRAKEN2_DB_NAME/taxonomy/taxdump.tar.gz
cp ${REPO}/.github/data/kraken2/nucl_gb_only_human_and_sars-cov-2.accession2taxid $KRAKEN2_DB_NAME/taxonomy
kraken2-build --db $KRAKEN2_DB_NAME --download-library human --no-mask
kraken2-build --db $KRAKEN2_DB_NAME --add-to-library ${REPO}/.github/data/kraken2/MN908947.3.kraken_annotated.fa
kraken2-build --db $KRAKEN2_DB_NAME --build --max-db-size 1000000000

bracken-build -d $KRAKEN2_DB_NAME -l 150

kraken2-build --db $KRAKEN2_DB_NAME --clean

