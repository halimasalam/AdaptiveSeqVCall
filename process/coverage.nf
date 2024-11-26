// Calculate coverage for target and non-target regions using mosdepth
process calculate_coverage {
    input:
        tuple path subset_bam, path subset_bam_index
        path target_bed
        path non_target_bed

    output:
        path "${params.outdir}/coverage_report"

    script:
    """
    mosdepth --by $target_bed ${params.outdir}/total.target $bam_file
    mosdepth --by $non_target_bed ${params.outdir}/total.nontarget $bam_file
    mosdepth --by $target_bed ${params.outdir}/subset.target $subset_bam
    mosdepth --by $non_target_bed ${params.outdir}/subset.nontarget $subset_bam
    """
}