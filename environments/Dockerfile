FROM continuumio/miniconda3:latest

COPY environments/environment.yml /environment.yml
RUN apt-get update && apt-get install -y curl g++ git make procps && apt-get clean -y
RUN /opt/conda/bin/conda env create -f /environment.yml 
ENV PATH=/opt/conda/envs/dehost-and-verify/bin:$PATH
