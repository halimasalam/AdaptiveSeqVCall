process call_variants_clair3 {
    input:
        tuple val(sample_id), path(bam), path(reference)
        val model_path
        val threads

    output:
        path "${sample_id}_clair3_output"

    script:
    """
    run_clair3.sh \
      --bam_fn=$bam \
      --ref_fn=$reference \
      --threads=$threads \
      --platform="ont" \
      --model_path=$model_path \
      --output=${sample_id}_clair3_output \
      --sample_name=$sample_id
    """
}
