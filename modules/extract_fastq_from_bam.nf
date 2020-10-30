process extract_fastq_from_bam {
    tag { sample_id }
    label 'cpu4'
    publishDir "${params.outdir}/dehosted_fastq", pattern: "${sample_id}_R*.dehost.fastq.gz", mode: 'copy'
    
    input:
    tuple val(sample_id), path(unmapped_bam)

    output:
    tuple val(sample_id), path("${sample_id}_R*.fastq.gz")

    script:
    """
    samtools fastq \
      -@ ${task.cpus} \
      ${unmapped_bam} \
      -1 ${sample_id}_R1.dehost.fastq.gz \
      -2 ${sample_id}_R2.dehost.fastq.gz \
      -s ${sample_id}_singletons.dehost.fastq.gz
    """
}
