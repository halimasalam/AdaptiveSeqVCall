process prepare_bed_files {
    input:
        path reference_genome
        path target_bed

    output:
        path("genome_file.genome")
        path("CancerPanelAll.sorted.bed")
        path("CancerPanelAll.nontarget.bed")

    script:
    """
    samtools faidx $reference_genome
    cut -f1,2 ${reference_genome}.fai > genome_file.genome
    bedtools sort -g genome_file.genome -i $target_bed > CancerPanelAll.sorted.bed
    bedtools complement -i CancerPanelAll.sorted.bed -g genome_file.genome > CancerPanelAll.nontarget.bed
    """
}
