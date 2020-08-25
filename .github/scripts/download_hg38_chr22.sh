#!/bin/bash
set -eo pipefail

echo Download hg38 chr22.. >> artifacts/test_artifact.log

mkdir -p ${HOME}/data
wget -P ${HOME}/data https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr22.fa.gz
gunzip ${HOME}/data/chr22.fa.gz

# environment name is suffixed by long alphanumeric string
# but it always starts with 'dehost-and-verify'. Use grep to find it.
source /opt/miniconda3/bin/activate $(conda info --envs | grep dehost-and-verify | cut -d ' ' -f 1)

bwa index ${HOME}/data/chr22.fa
