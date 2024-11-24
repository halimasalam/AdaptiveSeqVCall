# Bioinformatics Project
A PROJECT ON COMPARISON OF VARIANT CALLING IN NANOPORE ADAPTIVE SAMPLING SEQUENCING TO WHOLE GENOME SEQUENCING

## Input Data
Place your sequencing data (FASTQ files) in a directory and provide the directory path using the `--input_dir` parameter. The pipeline will automatically detect files with the `.fastq.gz` or `.fq.gz` extensions.

### Example Command
nextflow run my_pipeline.nf --input_dir /path/to/fastq_folder
