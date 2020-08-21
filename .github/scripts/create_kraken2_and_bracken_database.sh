#!/bin/bash
set -eo pipefail

echo Create kraken2 db .. >> artifacts/test_artifact.log

conda init bash
# environment name is suffixed by long alphanumeric string
# but it always starts with 'dehost-and-verify'. Use grep to find it.
conda activate $(conda info --envs | grep dehost-and-verify | cut -d ' ' -f 1)

KRAKEN2_DB_NAME=${HOME}/data/kraken2_bracken_db

kraken2-build --db $KRAKEN2_DB_NAME --download-taxonomy
kraken2-build --db $KRAKEN2_DB_NAME --download-library human --no-mask
kraken2-build --db $KRAKEN2_DB_NAME --download-library viral
kraken2-build --db $KRAKEN2_DB_NAME --build

bracken-build -d $KRAKEN2_DB_NAME -l 150

kraken2-build --db $KRAKEN2_DB_NAME --clean

