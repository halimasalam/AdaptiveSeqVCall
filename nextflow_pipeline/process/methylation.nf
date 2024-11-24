process call_methylation {
    input:
        tuple path bam_file, path bam_index
        path reference_genome
    output:
        path "${params.outdir}/methylation_output/methylation_calls.bed"  // Methylation calls in BED format
    script:
        """
        modbam2bed -e -m 5mC --cpg -t 4 $reference_genome $bam_file > ${params.outdir}/methylation_output/methylation_calls.bed
        """
}