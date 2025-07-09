process csv_to_bed {
    input:
    path csv_file

    output:
    path "GIAB_ex_Clair3.bed"

    script:
    """
    tail -n +2 ${csv_file} | awk -F',' '{print \$1"\t"\$2"\t"\$2+1}' > GIAB_ex_Clair3.bed
    """
}
