process align_reads {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(fastq_file)
    path reference from file(params.reference_genome)

    output:
    tuple val(sample_id), path("results/bam/${sample_id}.bam"), path("results/bam/${sample_id}.bam.bai")

    script:
    """
    mkdir -p results/bam
    minimap2 -ax map-ont $reference $fastq_file | \
        samtools sort -o results/bam/${sample_id}.bam -
    samtools index results/bam/${sample_id}.bam
    """
}
