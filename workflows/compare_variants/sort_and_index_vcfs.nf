process sort_and_index_vcf {
    input:
    path vcf_file

    output:
    path "*.vcf.gz"
    path "*.vcf.gz.tbi"

    script:
    def base = vcf_file.baseName
    """
    bcftools sort ${vcf_file} -o ${base}s.vcf
    bgzip -c ${base}s.vcf > ${base}.vcf.gz
    tabix -p vcf ${base}.vcf.gz
    """
}
