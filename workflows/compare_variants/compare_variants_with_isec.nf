process compare_variants_with_isec {
    input:
    path giab_vcf_gz
    path clair_vcf_gz

    output:
    path "isec_output"

    script:
    """
    mkdir -p isec_output
    bcftools isec -p isec_output ${giab_vcf_gz} ${clair_vcf_gz}
    """
}
