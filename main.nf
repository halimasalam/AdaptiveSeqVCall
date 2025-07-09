include { qc } from './workflows/qc.nf'
include { map_reads } from './workflows/mapping.nf'
include { subset_bam } from './workflows/subsetting.nf'
include { prepare_bed_files } from './workflows/prepare_bed_files.nf'
include { calculate_coverage } from './workflows/coverage.nf'
include { call_sv } from './workflows/variant_calling/call_sv.nf'
include { extract_methylation } from './workflows/methylation.nf'
include { call_variants_clair3 } from './workflows/variant_calling/call_variants_clair3'
include { phase_with_longphase } from './workflows/phasing.nf'
include { annotate_with_annovar } from './workflows/annotation/annotate_with_annovar.nf'
include { annotate_sv_svanna } from './workflows/annotation/annotate_sv_svanna.nf'
include { intersect_target_with_giab } from './workflows/compare_variants/intersect_target_with_giab.nf'
include { filter_vcf_by_region }       from './workflows/compare_variants/filter_vcf_by_region.nf'
include { sort_and_index_vcf }         from './workflows/compare_variants/sort_and_index_vcf.nf'
include { compare_variants_with_isec } from './workflows/compare_variants/compare_variants_with_isec.nf'
include { extract_uncalled_positions } from './workflows/compare_variants/extract_uncalled_positions.nf'
include { csv_to_bed }                 from './workflows/compare_variants/csv_to_bed.nf'
include { depth_extraction_mosdepth } from './workflows/compare_variants/depth_extraction_mosdepth.nf'
include { happy_comparison }           from './workflows/compare_variants/happy_comparison.nf'


// Resolve FASTQ 
// Load sample sheet into channel
samples = Channel
    .fromPath(params.samplesheet ?: "sample_sheet.csv")
    .splitCsv(header: true, sep: '\t')  // update separator if needed
    .map { row -> 
        def sample_id     = row.sample_id
        def sample_type   = row.sample_type
        def fastq_paths   = row.input_path.split(';').collect { file(it.trim()) }
        def summary_path  = file(row.summary_path)
        tuple(sample_id, sample_type, fastq_paths, summary_path)
    }


// Start the main workflow
workflow {

    reference_genome = file(params.reference_genome)
    target_bed = file(params.target_bed)
    bed_non_target = file(params.non_target_bed_file)
    summary_file = file(params.sequencing_summary)
    giab_bed = file(params.giab_bed)
    giab_bed         = file(params.giab_bed)
    giab_vcf         = file(params.giab_vcf)

    // Quality control
    qc_output = qc(summary_file, reads)

    // Mapping: Perform alignment for each sample, aligned_bams is a tuple: (sample_id, BAM, BAM index)
    aligned_bams = map_reads(samples, reference_genome)

    // Subsetting mapped BAM
    subsetted_bams = subset_bam(aligned_bams, target_bed)
    bam_file = subsetted_bams.map { it[1] }

    // Prepare BED files
    bed_files = prepare_bed_files(reference_genome, target_bed)

    // Calculate coverage
    coverage_output = calculate_coverage(subsetted_bams, bed_target, bed_non_target)

    // Methylation
    methylation_output = extract_methylation(subsetted_bams, reference)
    sv_calls = call_sv(subsetted_bams, reference)

    // Run cuteSV and sniffles for SV
    sv_calls = call_sv(subsetted_bams, reference)

    // Run Clair3 for SNV and indels
    clair3_results = call_variants_clair3(sample_id, sorted_bam, reference_genome, params.clair3_model_path, 8)
    clair_vcf = clair3_results.vcf

    // Run LongPhase phasing + tagging
    phased_results = phase_with_longphase(sample_id, clair3_results.vcf, sorted_bam, reference_genome, 8)

    // Annotate variants (Requires license agreement)
    annovar_output = annotate_with_annovar(clair3_results.vcf, file(params.annovar_dir), file(params.annovar_db))

    // SV annotation with SvAnna
    sv_annotated_sniffles = annotate_sv_svanna(sample_id, sniffles_vcf, file(params.svanna_jar), file(params.svanna_db))
    sv_annotated_cutesv   = annotate_sv_svanna(sample_id, cutesv_vcf, file(params.svanna_jar), file(params.svanna_db))

    // === VARIANT COMPARISON ===

    // Intersect GIAB and target panel BED
    intersected_bed = intersect_target_with_giab(giab_bed, target_bed)

    // Filter VCFs by BED region
    filtered_clair = filter_vcf_by_region(tuple("clair3", clair_vcf), intersected_bed)
    filtered_giab  = filter_vcf_by_region(tuple("giab", giab_vcf), intersected_bed)

    // Sort & index VCFs
    sorted_clair = sort_and_index_vcf(filtered_clair)
    sorted_giab  = sort_and_index_vcf(filtered_giab)

    // Join BAM and VCF per sample by sample_id
    sample_bam_vcf = subsetted_bams.map { sid, bam, bai -> tuple(sid, bam) }
                        .join(
                            sorted_clair.map { sid, vcf -> tuple(sid, vcf) },
                            by: 0
                        )

    // Variant intersection with BCFtools
    sample_bam_vcf.map { sid, bam, vcf ->
        compare_variants_with_isec(sorted_giab[0], vcf)
    }

    // Extract uncalled positions for each sample
    sample_bam_vcf.map { sid, bam, vcf ->
        extract_uncalled_positions(file("isec_output/0000.vcf"))
    }

    // Convert CSV to BED
    bed_from_csv = csv_to_bed(file("GIAB_chrom.csv"))

    // Run mosdepth for depth at missing positions
    sample_bam_vcf.map { sid, bam, vcf ->
        extract_depth_with_mosdepth(bed_from_csv, bam)
    }

    // Run hap.py comparison
    sample_bam_vcf.map { sid, bam, clair_vcf ->
        happy_comparison(sorted_giab[0], clair_vcf, intersected_bed, reference)
    }
}




