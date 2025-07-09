process annotate_sv_svanna {
    input:
        tuple val(sample_id), path(vcf)
        path svanna_jar
        path svanna_db

    output:
        path "${sample_id}_svanna_output"

    script:
    """
    mkdir ${sample_id}_svanna_output

    java -jar $svanna_jar prioritize \
        -d $svanna_db \
        --vcf $vcf \
        --out-dir ${sample_id}_svanna_output \
        --uncompressed-output \
        --output-format html,vcf,csv
    """
}
