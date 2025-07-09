process subset_bam {
    tag "$sample_id"

    input:
        tuple val(sample_id), path(bam), path(bam_index)
        path target_bed

    output:
        tuple val(sample_id), path("results/subset_bam/${sample_id}.subset.bam"), path("results/subset_bam/${sample_id}.subset.bam.bai")

    script:
    """
    mkdir -p results/subset_bam
    samtools view -b -L $target_bed $bam > results/subset_bam/${sample_id}.subset.bam
    samtools index results/subset_bam/${sample_id}.subset.bam
    """
}
