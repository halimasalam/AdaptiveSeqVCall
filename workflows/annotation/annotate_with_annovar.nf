process annotate_with_annovar {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(vcf_file)
    path annovar_dir
    path annovar_db

    output:
    path "${sample_id}_annovar.csv"

    script:
    """
    # Convert VCF to Annovar input format
    ${annovar_dir}/convert2annovar.pl -format vcf4 ${vcf_file} > ${sample_id}.avinput

    # Annotate using table_annovar
    ${annovar_dir}/table_annovar.pl ${sample_id}.avinput ${annovar_db} \
        -buildver hg38 \
        -out ${sample_id}_annovar \
        -remove \
        -protocol refGene,cytoBand,exac03,avsnp147,dbnsfp30a,clinvar_20220320 \
        -operation g,r,f,f,f,f \
        -nastring . \
        -csvout \
        -polish
    """
}
