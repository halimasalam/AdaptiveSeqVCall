# **Bioinformatics Project** 
**A PROJECT ON COMPARISON OF VARIANT CALLING IN NANOPORE ADAPTIVE SAMPLING SEQUENCING TO WHOLE GENOME SEQUENCING (On-going).**

This project provides a bioinformatics pipeline designed to analyze and compare sequencing data for the NA12878 reference genome using both standard WGS and adaptive sampling. 

The pipeline is implemented using Nextflow and can be run inside a Docker container, simplifying dependency management and ensuring reproducibility. Each `.nf` file contains one or more processes, and these processes are used in the `main.nf` to create the final pipeline.

## **Table of Content**
1. [Project Overview](#project-overview)
2. [Installation](#installation)
   1. [1. Install Nextflow](#install-nextflow)
   2. [2. Install Docker](#install-docker)
   3. [3. Build Docker Image](#build-docker-image)
3. [Running the Pipeline](#running-the-pipeline)
   1. [With Docker](#with-docker)
   2. [Without Docker](#without-docker)
4. [Input Files](#input-files)
5. [Output Files](#output-files)
6. [Dependencies](#dependencies)


## **Project  Overview**
This pipeline is designed to process **Whole Genome Sequencing (WGS)** data and compare it with **Adaptive Sampling (ONT)** sequencing. It performs the following tasks:

- **Quality Control** (QC) using NanoPlot
- **Read Mapping** using Minimap2
- **Coverage Calculation** for target and non-target regions using mosdepth
- **Subsetting BAM Files** for target and non target regions based on a BED file using BedTools,samtools and ont-fast5-api
- **Variant Calling** (SNV and indels using Claire3, Structural Variants using Sniffles and CuteSV)
- **Annotation and prioritiation** SNV ans SVs with annovar,SvAnna and SURVIVOR
- **Methylation Analysis** using modbam2bed for methylation calling 
- **Phasing|** longphase

The pipeline takes raw FASTQ files, a reference genome, and a BED file with target regions as input. It performs all necessary steps to analyze the data and generate results such as **VCF files**, **coverage reports**, and **methylation results**.


## **Installation**
### **1. Install Nextflow**
To install Nextflow, follow the official Nextflow installation guide or use the following commands for Linux or macOS:
```bash
curl -s https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin
```
### **2. Install Docker**
If you don’t already have Docker installed, you can install it by following the official guide:
Docker Installation Guide

For Linux, the installation might look like:
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```
For other systems, please refer to the Docker installation guide above.

### **3. Build Docker Image**
This project comes with a Dockerfile that encapsulates all the dependencies required to run the Nextflow pipeline.
To build the Docker image:
```bash
docker build -t bio-pipeline .
```
This will create a Docker image named bio-pipeline containing the necessary environment and tools.


## **Running the Pipeline**
### **1. With Docker**
You can run the pipeline inside the Docker container, which ensures all dependencies are installed and configured properly.

**a. Run the Docker container:**
```bash
docker run -v /path/to/your/data:/app/data bio-pipeline
```
Replace /path/to/your/data with the actual path where your data files are stored on your host system. This will mount the data directory inside the container at /app/data.

### **b. Access the container interactively (optional)**

**If you need to run commands interactively inside the container:**
```bash
docker run -it -v /path/to/your/data:/app/data bio-pipeline /bin/bash
```
This will give you a shell prompt inside the container where you can manually execute commands if needed.

### **2. Without Docker**
If you don't want to use Docker, you can manually install all dependencies in your environment, but using Docker simplifies this process.
**a. Install dependencies manually:**
- Nextflow: Install via Nextflow installation guide.
- Conda: Install Conda via the Conda website.
- Other dependencies: Install FastQC, BWA, Samtools, Minimap2, Sniffles, Mosdepth, NanoPlot, and others from either Conda or the appropriate package manager for your OS.

**b. Run the pipeline:**
After installing dependencies, you can run the pipeline with:
```bash
nextflow run main.nf
```


## **Input Files**
The following input files should be provided:

1. **FASTQ Files**: These can be in any directory, but must be named `.fastq.gz` or `.fq.gz`.
2. **Reference Genome**: A reference genome in FASTA format (`GRCh38.p14_canonical.fna` or similar).
3. **Target BED File**: A BED file specifying the target regions of interest for the analysis.
4. **Non-Target BED File**: A BED file specifying the non-target regions (complement of the target).
5. **Sequencing Summary**: A file containing sequencing run statistics used for QC with NanoPlot.


## **Output Files**
The following files are outputted:

1. **Mapped BAM File**: The aligned reads in BAM format (`mapped.bam`).
2. **Variant Call VCF**: Structural variants called from the BAM file (`sv_calls.vcf`).
3. **Subset BAM**: Subsetted BAM file based on target regions (`mapped.bam`).
3. **Coverage Statistics**:Coverage statistics for target and non-target regions (mosdepth output).
5. **Methylation Calls**: Methylation analysis results in `*.methylation_calls.txt` format.


## **Dependencies** 
The pipeline uses the following tools and libraries (to be updated):

- **Nextflow:** For workflow management.
- **Minimap2:** For mapping reads to the reference genome.
- **SAMtools:** For manipulating BAM files.
- **Mosdepth:** For calculating coverage.
- **Sniffles:** For variant calling (structural variants).
- **NanoPlot:** For quality control of sequencing data.
- **Bedtools:** For working with BED files.
These tools are automatically installed via Conda and Docker when using the provided Dockerfile.
