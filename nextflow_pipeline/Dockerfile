FROM continuumio/miniconda3:latest

# Set working directory
WORKDIR /app

# Copy the environment.yml to the container to create the conda environment
COPY environment.yml /app/

# Create the Conda environment from the environment.yml
RUN conda env create -f environment.yml

# Ensure that the bio_pipeline_env environment is activated
# This ensures that all the following commands will run in the conda environment
SHELL ["conda", "run", "-n", "bio_pipeline_env", "/bin/bash", "-c"]

# Install Nextflow via Conda (nextflow is already included in the environment.yml but installing explicitly for clarity)
RUN conda install -c conda-forge nextflow

# Copy the Nextflow pipeline files into the container
COPY . /app/

# Set the working directory again, just in case we need this for clarity
WORKDIR /app

# Run Nextflow when the container starts
CMD ["nextflow", "run", "main.nf"]
