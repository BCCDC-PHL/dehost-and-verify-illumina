#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { estimate_abundance as estimate_abundance_pre_dehosting } from './workflows/estimate_abundance.nf'
include { estimate_abundance as estimate_abundance_post_dehosting } from './workflows/estimate_abundance.nf'
include { dehost } from './workflows/dehost.nf'

if (params.profile){
    println("Profile should have a single dash: -profile")
    System.exit(1)
}

workflow {
    Channel.fromFilePairs( "${params.fastq_input}/*_R{1,2}*.fastq.gz", type: 'file', maxDepth: 1 ).set{ ch_fastq }
    Channel.fromPath( "${params.kraken2_db}", type: 'dir').set{ ch_kraken2_db }
    Channel.fromPath( "${params.bracken_db}", type: 'dir').set{ ch_bracken_db }
    ch_read_length = Channel.of(params.read_length)
    ch_taxonomy_level = Channel.of(params.taxonomy_level)
    ch_host_reference = Channel.of(params.host_reference)
    
    main:
      estimate_abundance_pre_dehosting(ch_fastq, ch_kraken2_db, ch_bracken_db, ch_read_length, ch_taxonomy_level)
      dehost(ch_fastq, ch_host_reference)
      estimate_abundance_post_dehosting(dehost.out, ch_kraken2_db, ch_bracken_db, ch_read_length, ch_taxonomy_level)
}
