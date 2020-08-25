#!/bin/bash
set -eo pipefail

echo Download hg38 .. >> artifacts/test_artifact.log

mkdir -p ${HOME}/data
wget -P ${HOME}/data https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/latest/hg38.fa.gz
gunzip ${HOME}/data/hg38.fa.gz

# environment name is suffixed by long alphanumeric string
# but it always starts with 'dehost-and-verify'. Use grep to find it.
conda activate $(conda info --envs | grep dehost-and-verify | cut -d ' ' -f 1)

bwa index ${HOME}/data/hg38.fa
