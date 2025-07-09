process filter_vcf_by_region {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(vcf)
    path giab_panel_bed

    output:
    path "${sample_id}_HC.vcf"

    script:
    """
    bcftools view -R ${giab_panel_bed} ${vcf} > ${sample_id}_HC.vcf
    """
}
