process bracken {
    tag { sample_id }

    input:
    tuple val(sample_id), path(kraken_report), path(bracken_db), val(read_length), val(taxonomy_level)

    output:
    tuple val(sample_id), path("${sample_id}_bracken_output.txt")
    
    script:
    """
    bracken \
      -d ${bracken_db} \
      -i ${kraken_report} \
      -l ${taxonomy_level} \
      -o ${sample_id}_bracken_output.txt \
      -w ${sample_id}_bracken_report.txt \
      -r ${read_length}
    """
}