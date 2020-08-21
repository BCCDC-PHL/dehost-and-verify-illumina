#!/bin/bash
set -eo pipefail

echo Download hg38 .. >> artifacts/test_artifact.log

mkdir -p ${HOME}/data
wget -P ${HOME}/data https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/latest/hg38.fa.gz
gunzip ${HOME}/data/hg38.fa.gz
