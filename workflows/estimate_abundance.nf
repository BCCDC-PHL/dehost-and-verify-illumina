nextflow.enable.dsl = 2

include { kraken2 } from '../modules/kraken2.nf'
include { bracken } from '../modules/bracken.nf'

workflow estimate_abundance {
  take:
    ch_fastq
    ch_kraken2_db
    ch_bracken_db
    ch_read_length
    ch_taxonomy_level

  main:
    kraken2(ch_fastq.combine(ch_kraken2_db))
    bracken(kraken2.out.combine(ch_bracken_db).combine(ch_read_length).combine(ch_taxonomy_level))
    

  emit:
    bracken_output = bracken.out
}