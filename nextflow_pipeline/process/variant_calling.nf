process call_sv {
    input:
        tuple path bam_file, path bam_index
        path reference_genome
    output:
        path "${params.outdir}/sv_output/sv_calls.vcf" 
    script:
        """
        sniffles --input $bam_file --reference $reference_genome --vcf ${params.outdir}/sv_output/sv_calls.vcf
        """
}