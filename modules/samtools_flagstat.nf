process samtools_flagstat {
    tag { sample_id }

    input:
    tuple val(sample_id), path(sorted_bam)

    output:
    path("${sample_id}.flagstats.txt") 

    script:
    """
    samtools flagstat \
      ${sorted_bam} > \
      ${sample_id}.flagstats.txt
    """
}