process phase_with_longphase {
    input:
        tuple val(sample_id), path(vcf), path(bam), path(reference)
        val threads

    output:
        path "phased_${sample_id}.vcf"
        path "tagged_bam_${sample_id}.bam"

    script:
    """
    ./longphase_linux-x64 phase \
        -s $vcf -b $bam -r $reference -t $threads \
        -o phased_${sample_id} --ont

    ./longphase_linux-x64 haplotag \
        -s phased_${sample_id}.vcf \
        -b $bam -t $threads -o tagged_bam_${sample_id}
    """
}
