process remove_mapped_reads {
    tag { sample_id }

    input:
    tuple val(sample_id), path(sorted_bam)

    output:
    tuple val(sample_id), path("${sample_id}.unmapped.sorted.bam")

    script:
    """
    samtools view \
      -@ ${cpus} \
      -f4 \
      -b  \
      -o ${sample_id}.unmapped.sorted.bam \
      ${sorted_bam}
    """
}