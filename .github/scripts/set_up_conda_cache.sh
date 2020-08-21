#!/bin/bash

export PATH=${HOME}/bin:/opt/miniconda3/bin:$PATH


# first NF run will create the conda env in the cache dir
echo run pipeline with conda --cache to create cache.. >> artifacts/test_artifact.log
export REPO=${PWD}
echo REPO=${REPO} >> artifacts/test_artifact.log
cd ..
echo PWD=${PWD} >> ${REPO}/artifacts/test_artifact.log
nextflow run ${REPO} \
       -profile conda \
       --cache ${HOME}/.conda/envs \
       --fastq_input .github/data/fastqs \
       --outdir output
cp .nextflow.log artifacts/cache_creation.conda.profile.nextflow.log

cat .nextflow.log | grep 'Conda create complete env=/home/runner/work/dehost-and-verify-illumina/dehost-and-verify-illumina/environments/environment.yml path=/home/runner/work/.conda/envs/dehost-and-verify-' \
    && echo "Conda env created in cache dir" >> artifacts/test_artifact.log \
	|| bash -c "echo test failed\: Conda environment not created as expected >> artifacts/test_artifact.log && exit 1"
    
rm -rf output && rm -rf work && rm -rf .nextflow*
# second NF run will use the conda env created in the previous run
echo re-run pipeline with conda --cache.. >> ${REPO}/artifacts/test_artifact.log
NXF_VER=20.03.0-edge nextflow run ${REPO} \
       -profile conda \
       --cache ${HOME}/.conda/envs \
       --fastq_input .github/data/fastqs \
       --outdir output
cp .nextflow.log artifacts/cache_use.conda.profile.nextflow.log

cat .nextflow.log | grep 'Conda found local env for environment=/home/runner/work/dehost-and-verify-illumina/dehost-and-verify-illumina/environments/environment.yml; path=/home/runner/.conda/envs/dehost-and-verify-' \
    && echo "Conda env found in cache dir" >> artifacts/test_artifact.log \
	|| bash -c "echo test failed\: Conda environment not not found in cache dir >> artifacts/test_artifact.log && exit 1"

# clean-up for following tests
rm -rf output && rm -rf work && rm -rf .nextflow*
