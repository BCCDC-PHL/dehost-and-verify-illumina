process extract_fastq_from_bam {
    tag { sample_id }
    
    publishDir "${params.outdir}/dehosted_fastq", pattern: "${sample_id}_R*.fastq.gz", mode: 'copy'
    input:
    tuple val(sample_id), path(unmapped_bam)

    output:
    tuple val(sample_id), path("${sample_id}_R*.fastq.gz")

    script:
    """
    samtools fastq \
      -@ ${task.cpus} \
      ${unmapped_bam} \
      -1 ${sample_id}_R1.fastq.gz \
      -2 ${sample_id}_R2.fastq.gz \
      -s ${sample_id}_singletons.fastq.gz
    """
}