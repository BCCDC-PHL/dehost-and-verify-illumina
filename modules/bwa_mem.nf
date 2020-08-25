process bwa_mem {
    tag { sample_id }
    label 'cpu8'

    input:
    tuple val(grouping_key), path(fastq), val(reference)

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam")

    script:
    if (grouping_key =~ '_S[0-9]+_') {
      sample_id = grouping_key.split("_S[0-9]+_")[0]
    } else {
      sample_id = grouping_key.split("_")[0]
    }

    """
    ln -s ${reference} .
    ln -s ${reference}.amb .
    ln -s ${reference}.ann .
    ln -s ${reference}.bwt .
    ln -s ${reference}.pac .
    ln -s ${reference}.sa .
    bwa mem \
      -t ${task.cpus} \
      ${reference} \
      ${fastq} \
      | samtools sort \
        -n \
        -@ ${task.cpus} \
        -T "temp" \
        -O BAM \
        -o ${sample_id}.sorted.bam \
        -
    """
}