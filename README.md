# **AdaptiveSeqVCall**  
**A Bioinformatics Pipeline for Comparative Variant Analysis in Nanopore Adaptive Sampling and Whole Genome Sequencing (WGS)**  


This project provides a modular bioinformatics pipeline designed to analyze and compare **Oxford Nanopore Adaptive Sampling** and **Whole Genome Sequencing (WGS)** datasets for the *NA12878* reference genome.The pipeline is implemented using **Nextflow** and can be run inside a Docker to portability and reproducibility across systems container. 
The pipeline automates preprocessing, alignment, variant calling (SNVs and SVs), methylation profiling, and comparative benchmarking.

Modules are defined in separate `.nf` files and composed in `main.nf` for execution.

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Pipeline Workflow](#pipeline-workflow)
3. [Installation](#installation)
   - [Install Nextflow](#install-nextflow)
   - [Install Docker](#install-docker)
   - [Build Docker Image](#build-docker-image)
4. [Running the Pipeline](#running-the-pipeline)
   - [With Docker](#with-docker)
   - [Without Docker](#without-docker)
5. [Input Files](#input-files)
6. [Output Files](#output-files)
7. [Dependencies](#dependencies)
8. [Annovar License and Installation](#annovar-license-and-installation)

---

## Project Overview

This pipeline enables comparative analysis of **Nanopore Adaptive Sampling** vs. **Whole Genome Sequencing** for NA12878. It performs:

- **Quality Control** using NanoPlot  
- **Read Mapping** with Minimap2  
- **Targeted/Non-targeted Subsetting** of BAMs using BedTools and samtools  
- **Coverage Analysis** using Mosdepth  
- **Variant Calling**
  - SNVs & Indels using **Clair3**
  - Structural Variants (SVs) using **Sniffles** and **CuteSV**
- **Methylation Extraction** using modbam2bed  
- **Phasing and Tagging** using **LongPhase**  
- **Variant Annotation**
  - SNVs via **Annovar**
  - SVs via **SvAnna**
- **Comparison with GIAB** using **bcftools isec**, **hap.py**, and **mosdepth**-based depth profiling

---

## Pipeline Workflow

The main workflow follows multiple modular stages:
1. **QC** with NanoPlot from `sequencing_summary.txt`
2. **Read Mapping** (Minimap2 to BAM)
3. **Subsetting** BAM files to target/non-target regions
4. **Coverage Calculation** for each region using mosdepth
5. **SNV Calling** using Clair3
6. **SV Calling** using Sniffles & CuteSV
7. **Phasing & Tagging** variants with LongPhase
8. **Annotation** of SNVs (Annovar) and SVs (SvAnna)
9. **Variant Comparison** with GIAB:
   - Subsetting GIAB regions
   - Filtering both VCFs
   - Sorting & indexing
   - Intersection and hap.py evaluation
   - Depth analysis for uncalled regions

Each step is parallelized by sample.

---

## Installation

### 1. Install Nextflow
```bash
curl -s https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin
```

### 2. Install Docker  
Follow the [official Docker installation guide](https://docs.docker.com/get-docker/).  
For Ubuntu:
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

### 3. Build Docker Image
```bash
docker build -t adaptive-seq-pipeline .
```

---

## Running the Pipeline

### 1. With Docker (Recommended)
Mount your data directory and run:
First, mount your working directory into the container to ensure the pipeline can access your input files and write outputs:

```bash
docker run -it -v /absolute_path/to/your/data:/app adaptive-seq-pipeline /bin/bash
```
**a. Using Command-Line Parameters:**
```bash
nextflow run main.nf \
  --samplesheet data/sample_sheet.csv \
  --reference_genome data/ref.fa \
  --target_bed data/targets.bed \
  --giab_bed data/giab_truth_set.bed \
  --bam_file data/aligned.bam \
  --clair_vcf results/clair3.vcf.gz \
  --giab_vcf data/giab.vcf.gz \
  --annovar_dir /app/annovar \
  --annovar_db /app/annovar/humandb \
  --svanna_jar /app/data/svanna-cli-1.0.1.jar \
  --svanna_db /app/data/svanna-db-dir
```

**b. With a Parameter File (`params.yaml`):**
```bash
nextflow run main.nf -params-file config/params.yaml 
```

This method is cleaner and more reproducible. See [Using `params.yaml`](#using-paramsyaml).


### 2. Without Docker
If you choose not to use Docker, you must **manually install all dependencies** in your local environment.
See the [Dependencies](#dependencies) section for the full list and installation suggestions.

Then run:
```bash
nextflow run main.nf --params_file config/params.yaml
```
---

## Input Files

| File Type | Description |
|----------------------------------|----------------------------------|
| `.fastq`                         | Input sequencing reads           |
| `reference.fasta`                | Reference genome (e.g. GRCh38)   |
| `target.bed`                     | Target capture panel (BED format)|
| `non_target.bed`                 | Complement regions (BED)         |
| `sequencing_summary.txt`         | From ONT Guppy/NanoPlot          |
| `giab.vcf.gz`                    | GIAB truth VCF                   |
| `giab.bed`                       | GIAB confident regions           |
| `clair3_model_path`              | Path to pre-trained Clair3 model |
| `annovar_dir`, `annovar_humandb` | Annovar scripts & databases      |
| `svanna_jar`, `svanna_db`        | SV annotation JAR and DB         |

---

## Sample Sheet (`sample_sheet.csv`)

Instead of specifying input directories directly, this pipeline uses a **sample sheet** CSV file to define each sample's metadata and input file paths. This ensures flexibility and clarity when handling multiple samples.

### Format

The file should be a **CSV** (or TSV) with the following column headers:

| Column Name    | Description                                              |
|----------------|----------------------------------------------------------|
| `sample_id`    | Unique identifier for the sample                         |
| `sample_type`  | Optional label for experimental grouping (e.g., WGS_SUP) |
| `input_path`   | Path to the sample’s `.fastq` or `.fastq.gz` file        |
| `summary_path` | Path to the corresponding `sequencing_summary.txt`       |

### Example: `sample_sheet.csv`

```csv
sample_id,sample_type,input_path,summary_path
S1,WGS_SUP,data/WGS_SUP/reads_1.fastq,data/WGS_SUP/sequencing_summary.txt
S2,WGS_HAC,data/WGS_HAC/reads_1.fastq,data/WGS_HAC/sequencing_summary.txt
S3,AS_HAC,data/AS_HAC/reads_1.fastq,data/AS_HAC/sequencing_summary.txt
S4,AS_SUP,data/AS_SUP/reads_1.fastq,data/AS_SUP/sequencing_summary.txt
```

## Output Files

| Output | Description |
|--------------------------------------|------------------------------------------|
| `*.bam`                              | Mapped BAM files                         |
| `*.bam.bai`                          | BAM indices                              |
| `*.vcf.gz`                           | Variant calls (Clair3, Sniffles, CuteSV) |
| `*.methylation_calls.txt`            | Methylation per region                   |
| `*.coverage.txt`                     | Coverage summaries (target & non-target) |
| `*_HC.vcf`                           | High-confidence region-filtered VCF      |
| `hap.py_*`                           | Benchmarking output from hap.py          |
| `GIAB_ex_Clair3.bed`                 | BED file of missing variant sites        |
| `mosdepth_GIAB_Clair_DP.regions.bed` | Depth file for missing sites             |

---

## **Configuration**

### Using `params.yaml`

To avoid specifying many parameters manually, define a `params.yaml` file in `config/` like:

```yaml
samplesheet: "data/sample_sheet.csv"
reference_genome: "data/GRCh38.p14.fna"
target_bed: "data/targets.bed"
non_target_bed_file: "data/non_targets.bed"
sequencing_summary: "data/sequencing_summary.txt"
giab_bed: "data/giab_truth_set.bed"
clair_vcf: "results/clair3.vcf.gz"
giab_vcf: "data/giab.vcf.gz"
bam_file: "results/aligned.bam"
annovar_dir: "/app/annovar"
annovar_db: "/app/annovar/humandb"
svanna_jar: "/app/data/svanna-cli-1.0.1.jar"
svanna_db: "/app/data/svanna-db-dir"
```

Then launch with:

```bash
nextflow run main.nf -params-file config/params.yaml
```

---

## Dependencies

All tools are installed via Docker (and optionally via Conda). Key tools include:

- `Nextflow` – Workflow engine  
- `Minimap2` – Long-read alignment  
- `Samtools` – BAM file utilities  
- `Mosdepth` – Coverage profiling  
- `NanoPlot` – Quality control  
- `Sniffles`, `CuteSV` – Structural variant callers  
- `Clair3` – SNV/indel calling  
- `LongPhase` – Variant phasing  
- `modbam2bed` – Methylation extraction  
- `Bcftools` – VCF manipulation  
- `Bedtools` – Region handling  
- `hap.py` – Variant benchmarking  
- `Annovar`, `SvAnna`, `SURVIVOR` – Variant annotation and merging  

---

## Annovar License and Installation

This pipeline includes optional **Annovar** annotation support, which **requires a license**.

To use Annovar:
1. Register at [Annovar website](http://www.openbioinformatics.org/annovar/annovar_download_form.php)
2. Download and extract:
   ```bash
   tar -xvzf annovar.latest.tar.gz
   ```
3. Set the paths:
   - In `nextflow.config`
   - Or at runtime:
     ```bash
     --annovar_dir /path/to/annovar \
     --annovar_humandb /path/to/annovar/humandb
     ```

---
