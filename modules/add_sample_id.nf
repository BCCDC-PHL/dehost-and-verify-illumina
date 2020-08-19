process add_sample_id {
    tag "$sample_id"
    cpus 1
    executor 'local'
    
    input:
    tuple val(sample_id), path(tsv_data_file_with_header)

    output:
    tuple val(sample_id), path("${sample_id}.txt")
    
    script:
    """
    mv ${tsv_data_file_with_header} input.tsv
    head -n 1 input.tsv > output_header_tmp.tsv
    echo 'sample_id' > sample_id.tsv
    paste sample_id.tsv output_header_tmp.tsv > output_header.tsv
    tail -n +2 input.tsv | awk '{print "${sample_id}\t" \$0}' > output_data.tsv
    cat output_header.tsv output_data.tsv > ${sample_id}_bracken_output.txt
    """
}