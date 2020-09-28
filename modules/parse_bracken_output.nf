process parse_bracken_output {
    tag { sample_id }
    executor 'local'
    publishDir "${params.outdir}/pathogen_host_read_summary", pattern: "${sample_id}_pathogen_host_read_summary_${analysis_stage}.tsv", mode: 'copy'
    input:
    tuple val(sample_id), path(bracken_output), val(host_name), val(pathogen_name), val(analysis_stage)

    output:
    tuple val(sample_id), path("${sample_id}_pathogen_host_read_summary_${analysis_stage}.tsv")
    
    script:
    """
    parse_bracken_output.py \
      --sample_id ${sample_id} \
      --host_name "${host_name}" \
      --pathogen_name "${pathogen_name}" \
      --analysis_stage ${analysis_stage} \
      ${bracken_output} > ${sample_id}_pathogen_host_read_summary_${analysis_stage}.tsv
    """
}
