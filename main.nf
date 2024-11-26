
include { map_reads,subset_bam } from '.processes/mapping.nf'
include { calculate_coverage } from '.processes/coverage.nf'
include { nanoplot_qc } from '.processes/qc.nf'
include { call_methylation } from '.processes/methylation.nf'
include { call_sv } from '.processes/variant_calling.nf'

// Step 1: Resolve FASTQ files from input directories
reads = params.input_dirs
    .collect { dir -> file("${dir}/*") }  
    .flatten()                           
    .filter { it.name.endsWith(".fastq.gz") || it.name.endsWith(".fq.gz") } 

// Validate that FASTQ files are found
if (!reads) {
    error "No FASTQ files found in the specified directories: ${params.input_dirs.join(', ')}."
}

// Step 2: Define the main workflow
workflow {
    reference_genome = file(params.reference_genome)         // Reference genome path
    target_bed = file(params.target_bed_file)                // Target regions file
    non_target_bed = file(params.non_target_bed_file)        // Non-target regions file
    sequencing_summary = file(params.sequencing_summary)     // Sequencing summary for QC

    // Step 3: Quality Control (QC) with NanoPlot
    qc_results = nanoplot_qc(sequencing_summary, reads)

    // Step 4: Map reads using Minimap2
    mapped_bam_tuple = map_reads(reads, reference_genome) 

    // Step 5: Subset BAM to target regions
    subset_bam_tuple = subset_bam(mapped_bam_tuple[0], target_bed)  

    // Step 6: Calculate coverage using Mosdepth
    coverage_results = calculate_coverage(
        bam_file = mapped_bam_tuple[0], 
        target_bed = target_bed, 
        non_target_bed = non_target_bed
    )

    // Step 7: Variant Calling with Sniffles
    variant_calls = call_sv(mapped_bam_tuple[0], reference_genome)

    // Methylation analysis with modbam2bed
    methylation_calls = call_methylation(mapped_bam_tuple[0], reference_genome)
}


