process qc {
    tag "$sample_id"

    input:
        tuple val(sample_id), val(sample_type), path(fastqs), path(summary_file)

    output:
        path "NanoPlot_${sample_id}"

    script:
    """
    mkdir -p NanoPlot_${sample_id}
    NanoPlot \\
        --summary $summary_file \\
        --fastq ${fastqs.join(' ')} \\
        -t 4 \\
        --outdir NanoPlot_${sample_id}
    """
}