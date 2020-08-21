#!/bin/bash
set -eo pipefail

echo Download hg38 .. >> artifacts/test_artifact.log

mkdir /data
wget -P /data https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/latest/hg38.fa.gz
gunzip /data/hg38.fa.gz
