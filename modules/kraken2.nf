process kraken2 {
    tag { sample_id }
    
    input:
    tuple val(grouping_key), path(reads), path(kraken2_db)

    output:
    tuple val(sample_id), path('*_kraken_report.txt')
    
    script:
    if (grouping_key =~ '_S[0-9]+_') {
      sample_id = grouping_key.split("_S[0-9]+_")[0]
    } else if (grouping_key =~ '_') {
      sample_id = grouping_key.split("_")[0]
    } else {
      sample_id = grouping_key
    }
    """
    kraken2 \
      --threads ${task.cpus} \
      --db ${kraken2_db} \
      --output ${sample_id}_kraken_output.txt \
      --report ${sample_id}_kraken_report.txt \
      --paired \
      ${reads}
    """
}