# De-Host And Verify for Illumina

The purpose of this pipeline is to remove host-associated reads from a pathogen sequencing project. This may be done to meet privacy and ethics requirements when analyzing samples that have been collected from human hosts, or as a quality control process to ensure that host-derived reads do not interfere with downstream processes such as genome assembly.

This pipeline performs the following tasks:

1. Estimates the relative abundances of reads originating from a host organism and a pathogen of interest using [kraken2](https://github.com/DerrickWood/kraken2) and [bracken](https://github.com/jenniferlu717/Bracken)
2. Performs 'de-hosting' by aligning reads against a reference genome using [bwa](https://github.com/lh3/bwa), and extracting unmapped reads using [samtools](https://github.com/samtools/samtools)
3. Verifies that the remaining reads do not contain host-derived sequenced by again estimating relative abundances using the same method as in step 1.
4. Prepares a brief report summarizing the efficacy of the de-hosting process.

![workflow.png][]

[workflow.png]: doc/images/workflow.png

## Parameters

| Parameter        | Default Value | Description |
| ---------------- | ------------- | ----------- |
| `kraken2_db`     |  | Path to kraken2 database |
| `bracken_db`     |  | Path to bracken database |
| `host_reference` |  | Path to host reference genome |
| `taxonomy_level` | `'S'` | Taxonomic level at which to group reads (`'S'` = Species) |
| `read_length`    | `150` | Input sequence read length. Must match bracken database. |
| `host_name`      | `'Homo sapiens'` | Name of host. Must match name in kraken2 database. |
| `pathogen_name`  | `'Severe acute respiratory syndrome-related coronavirus'` | Name of pathogen of interest. Must match name in kraken2 database. |

## Preparing Reference Datasets

Build a kraken2 database.
```
kraken2-build --db <path_to_kraken2_db> --standard
```

Build the bracken database.
```
bracken-build -d <path_to_kraken2_db> -l <read_length>
```

Index the host reference genome.
```
bwa index <path_to_host_reference>
```

## Outputs