process extract_methylation {
    tag "$sample_id"

    input:
        tuple val(sample_id), path(bam)
        path reference_genome

    output:
        path "${sample_id}_5mC.bed"
        path "${sample_id}_5hmC.bed"

    script:
    """
    modbam2bed -e -m 5mC --cpg -t 4 $reference_genome $bam > ${sample_id}_5mC.bed
    modbam2bed -e -m 5hmC --cpg -t 4 $reference_genome $bam > ${sample_id}_5hmC.bed
    """
}
