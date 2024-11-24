// Map reads using minimap2
process map_reads {
    input:
        path fastq_file          // FASTQ file passed from the workflow
        path reference_genome    // Reference genome file
    output:
        tuple path("${params.outdir}/mapped.bam"), path("${params.outdir}/mapped.bam.bai")  // Tuple output: BAM and index files
    script:
        """
        mkdir -p ${params.outdir}  # Ensure the output directory exists
        minimap2 -ax map-ont $reference_genome $fastq_file | \
            samtools sort -o ${params.outdir}/mapped.bam -T ${params.outdir}/reads.tmp
        samtools index ${params.outdir}/mapped.bam
        """
}

// Subset target regions from BAM using a BED file
process subset_bam {
    input:
        path bam_file from "${params.outdir}/mapped.bam"
        path target_bed

    output:
        tuple path "${params.outdir}/subset.bam", path("${params.outdir}/subset.bam.bai")  // Tuple output: BAM and index files

    script:
    """
    samtools view -b -L $target_bed $bam_file > ${params.outdir}/subset.bam
    samtools index ${params.outdir}/subset.bam
    """
}