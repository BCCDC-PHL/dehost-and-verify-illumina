nextflow.enable.dsl = 2

include { bwa_mem } from '../modules/bwa_mem.nf'
include { samtools_flagstat } from '../modules/samtools_flagstat.nf'
include { remove_mapped_reads } from '../modules/remove_mapped_reads.nf'
include { extract_fastq_from_bam } from '../modules/extract_fastq_from_bam.nf'

workflow dehost {
    take:
      ch_fastq_input
      ch_host_reference

    main:
      bwa_mem(
        ch_fastq_input
	  .combine(ch_host_reference)
      )
      
      samtools_flagstat(
        bwa_mem.out
      )
      
      remove_mapped_reads(
        bwa_mem.out
      )

      extract_fastq_from_bam(
        remove_mapped_reads.out
      )

    emit:
      dehosted_fastq = extract_fastq_from_bam.out
}
