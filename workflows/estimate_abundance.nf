nextflow.enable.dsl = 2

include { kraken2 } from '../modules/kraken2.nf'
include { bracken } from '../modules/bracken.nf'
include { parse_bracken_output } from '../modules/parse_bracken_output.nf'

workflow estimate_abundance {
  take:
    ch_fastq
    ch_kraken2_db
    ch_bracken_db
    ch_read_length
    ch_taxonomy_level
    ch_analysis_stage
    ch_host_name
    ch_pathogen_name

  main:
    kraken2(
      ch_fastq
        .combine(ch_kraken2_db)
    )
    
    bracken(
      kraken2.out
        .combine(ch_bracken_db)
	.combine(ch_read_length)
	.combine(ch_taxonomy_level)
	.combine(ch_analysis_stage)
    )
    
    parse_bracken_output(
      bracken.out
        .combine(ch_host_name)
	.combine(ch_pathogen_name)
	.combine(ch_analysis_stage)
    )

  emit:
    estimate_abundance_output = parse_bracken_output.out   

}
