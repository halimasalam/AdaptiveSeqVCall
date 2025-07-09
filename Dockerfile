FROM continuumio/miniconda3

WORKDIR /app

COPY environment.yml .

RUN conda env create -f environment.yml

SHELL ["conda", "run", "-n", "bio_pipeline_env", "/bin/bash", "-c"]

RUN conda install -c conda-forge nextflow

WORKDIR /app
CMD ["nextflow", "run", "main.nf"]
