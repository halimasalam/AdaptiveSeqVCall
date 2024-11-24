
FROM continuumio/miniconda3:latest

# Set working directory 
WORKDIR /app

# Copy the YAML file into the container
COPY environment.yml /app/

# Create the Conda environment 
RUN conda env create -f environment.yml

# Activate the Conda environment
SHELL ["conda", "run", "-n", "bio_pipeline_env", "/bin/bash", "-c"]

# Install Nextflow 
RUN conda install -c conda-forge nextflow

# Set the working directory 
WORKDIR /app

# Run Nextflow when the container starts
CMD ["nextflow", "run", "main.nf"]