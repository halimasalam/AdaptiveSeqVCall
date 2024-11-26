# **Bioinformatics Project**
A PROJECT ON COMPARISON OF VARIANT CALLING IN NANOPORE ADAPTIVE SAMPLING SEQUENCING TO WHOLE GENOME SEQUENCING (On-going)

## **1. Overview**
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

## **Pipeline Structure**

The pipeline consists of several processes defined across multiple `.nf` files. These processes are orchestrated in the `main.nf` file, which imports and executes the following:

- **`mapping.nf`**: Processes for mapping the reads to the reference genome.
- **`coverage.nf`**: Processes for calculating the coverage of both target and non-target regions.
- **`qc.nf`**: Processes for performing quality control using NanoPlot.
- **`variant_calling.nf`**: Processes for structural variant calling (e.g., using Sniffles).
- **`methylation.nf`**: Processes for methylation analysis (e.g., using Nanopolish).

Each `.nf` file contains one or more processes, and these processes are used in the `main.nf` to create the final pipeline.

## **Required Input Files**

The following input files should be provided:

1. **FASTQ Files**: These can be in any directory, but must be named `.fastq.gz` or `.fq.gz`.
2. **Reference Genome**: A reference genome in FASTA format (`GRCh38.p14_canonical.fna` or similar).
3. **Target BED File**: A BED file specifying the target regions of interest for the analysis.
4. **Non-Target BED File**: A BED file specifying the non-target regions (complement of the target).
5. **Sequencing Summary**: A file containing sequencing run statistics used for QC with NanoPlot.

## **Usage**

To run the pipeline, you need to have **Nextflow** installed. You can install it from [Nextflow’s website](https://www.nextflow.io/).

### **1. Clone the Repository**

```bash
git clone https://github.com/yourusername/nextflow-wgs-adaptive-sampling-pipeline.git
cd nextflow-wgs-adaptive-sampling-pipeline 
```

## **2. Install Nextflow**
If you don't have Nextflow installed, you can install it with the following commands:

```bash
curl -s https://get.nextflow.io | bash
```