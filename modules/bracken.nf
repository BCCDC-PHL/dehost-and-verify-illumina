process bracken {
    tag { sample_id }
    publishDir "${params.outdir}/bracken_output", pattern: "${sample_id}_bracken_output_${analysis_stage}.txt", mode: 'copy'

    input:
    tuple val(sample_id), path(kraken_report), path(bracken_db), val(read_length), val(taxonomy_level), val(analysis_stage)

    output:
    tuple val(sample_id), path("${sample_id}_bracken_output_${analysis_stage}.txt")
    
    script:
    """
    bracken \
      -d ${bracken_db} \
      -i ${kraken_report} \
      -l ${taxonomy_level} \
      -o ${sample_id}_bracken_output_${analysis_stage}.txt \
      -w ${sample_id}_bracken_report_${analysis_stage}.txt \
      -r ${read_length}
    """
}