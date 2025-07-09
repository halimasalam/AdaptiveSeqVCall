process call_sv {
    tag "$sample_id"

    input:
        tuple val(sample_id), path(bam)
        path reference_genome

    output:
        path "${sample_id}_sniffles.vcf"
        path "${sample_id}_cutesv.vcf"

    script:
    """
    sniffles --input $bam --reference $reference_genome --vcf ${sample_id}_sniffles.vcf
    cuteSV $bam $reference_genome ${sample_id}_cutesv.vcf ./
    """
}
