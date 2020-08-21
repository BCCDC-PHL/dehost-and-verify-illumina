#!/bin/bash
set -eo pipefail

echo Download ncov2019 .. >> artifacts/test_artifact.log

mkdir -p ${HOME}/data
wget -P ${HOME}/data https://raw.githubusercontent.com/artic-network/artic-ncov2019/master/primer_schemes/nCoV-2019/V1/nCoV-2019.reference.fasta
mv ${HOME}/data/nCoV-2019.reference.fasta ${HOME}/data/MN908947.3.fa
