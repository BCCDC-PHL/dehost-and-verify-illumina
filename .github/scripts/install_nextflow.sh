#!/bin/bash
set -eo pipefail

echo Install Nextflow .. >> artifacts/test_artifact.log

mkdir ${HOME}/bin
export PATH=${HOME}/bin:$PATH
wget -qO- https://get.nextflow.io | bash
mv ./nextflow ${HOME}/bin

