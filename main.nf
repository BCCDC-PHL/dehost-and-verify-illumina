#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { estimate_abundance as estimate_abundance_pre_dehosting } from './workflows/estimate_abundance.nf'
include { estimate_abundance as estimate_abundance_post_dehosting } from './workflows/estimate_abundance.nf'
include { dehost } from './workflows/dehost.nf'
include { combine_pre_and_post_dehosting } from './modules/combine_pre_and_post_dehosting.nf'

if (params.profile){
    println("Profile should have a single dash: -profile")
    System.exit(1)
}

workflow {
    Channel.fromFilePairs( "${params.fastq_input}/*_R{1,2}*.fastq.gz", type: 'file', maxDepth: 1 ).filter{!( it[0] =~ /Undetermined/ ) }.set{ ch_fastq }
    Channel.fromPath( "${params.kraken2_db}", type: 'dir').set{ ch_kraken2_db }
    Channel.fromPath( "${params.bracken_db}", type: 'dir').set{ ch_bracken_db }
    ch_read_length = Channel.of(params.read_length)
    ch_taxonomy_level = Channel.of(params.taxonomy_level)
    ch_host_reference = Channel.of(params.host_reference)
    ch_host_name = Channel.of(params.host_name)
    ch_pathogen_name = Channel.of(params.pathogen_name)
    ch_pre_dehosting_stage = Channel.of('pre_dehosting')
    ch_post_dehosting_stage = Channel.of('post_dehosting')
    
    main:
      estimate_abundance_pre_dehosting(
        ch_fastq,
	ch_kraken2_db,
	ch_bracken_db,
	ch_read_length,
	ch_taxonomy_level,
	ch_pre_dehosting_stage,
	ch_host_name,
	ch_pathogen_name
      )

      dehost(
        ch_fastq,
	ch_host_reference
      )

      estimate_abundance_post_dehosting(
        dehost.out,
	ch_kraken2_db,
	ch_bracken_db,
	ch_read_length,
	ch_taxonomy_level,
	ch_post_dehosting_stage,
	ch_host_name,
	ch_pathogen_name
      )

      combine_pre_and_post_dehosting(
	estimate_abundance_pre_dehosting.out.estimate_abundance_output
	   .join(estimate_abundance_post_dehosting.out.estimate_abundance_output, by: 0)
      )

     combine_pre_and_post_dehosting.out.collectFile(name: 'dehosting_summary.tsv', storeDir: "${params.outdir}", keepHeader: true) 
}
