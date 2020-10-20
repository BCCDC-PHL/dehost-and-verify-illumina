process combine_pre_and_post_dehosting {
    tag { sample_id }
    executor 'local'

    input:
    tuple val(sample_id), path(pre_dehosting), path(post_dehosting)

    output:
    tuple val(sample_id), path("${sample_id}_dehosting_report.tsv")
    
    script:
    """
    paste ${pre_dehosting} ${post_dehosting} | cut --complement -f5 > ${sample_id}_dehosting_report.tsv
    """
}
