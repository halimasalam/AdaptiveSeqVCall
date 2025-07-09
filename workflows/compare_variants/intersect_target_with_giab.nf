process intersect_target_with_giab {
    input:
    path giab_bed
    path target_bed

    output:
    path "GIAB_CPanel.bed"

    script:
    """
    bedtools intersect -a ${giab_bed} -b ${target_bed} > GIAB_CPanel.bed
    """
}
