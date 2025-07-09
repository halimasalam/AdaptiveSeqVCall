process extract_depth_with_mosdepth {
    input:
    path bed_file
    path bam_file

    output:
    path "mosdepth_GIAB_Clair_DP.regions.bed"

    script:
    """
    mosdepth --by ${bed_file} mosdepth_GIAB_Clair_DP ${bam_file}
    mv mosdepth_GIAB_Clair_DP.regions.bed mosdepth_GIAB_Clair_DP.regions.bed
    """
}
