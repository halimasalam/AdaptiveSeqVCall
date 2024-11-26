process nanoplot_qc {
    input:
        path sequencing_summary    // Path to sequencing summary file (e.g., FAL73976_3461bedd.txt)
        path fastq_file            // FASTQ file(s) for which QC is being performed
    output:
        path "${params.outdir}/nanoplot_report" // Directory containing the NanoPlot report
    script:
        """
        mkdir -p ${params.outdir}/nanoplot_report  # Ensure output directory exists
        NanoPlot --summary $sequencing_summary -t 2 --outdir ${params.outdir}/nanoplot_report
        """
}