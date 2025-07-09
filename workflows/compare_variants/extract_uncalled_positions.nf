process extract_uncalled_positions {
    input:
    path missing_vcf  // This is isec_output/0000.vcf

    output:
    path "GIAB_chrom.csv"

    script:
    """
    gatk VariantsToTable -V ${missing_vcf} -F CHROM -F POS -O GIAB_chrom.csv
    """
}
