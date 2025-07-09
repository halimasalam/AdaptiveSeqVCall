process calculate_coverage {
    tag "$sample_id"

    input:
        tuple val(sample_id), path(bam), path(bam_index)
        path target_bed
        path nontarget_bed

    output:
        path "results/coverage/${sample_id}_target_coverage*"
        path "results/coverage/${sample_id}_nontarget_coverage*"

    script:
    """
    mkdir -p results/coverage
    mosdepth --by $target_bed results/coverage/${sample_id}_target_coverage $bam
    mosdepth --by $nontarget_bed results/coverage/${sample_id}_nontarget_coverage $bam
    """
}
