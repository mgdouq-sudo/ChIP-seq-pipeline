#!/usr/bin/env nextflow

process TAGDIR {

label 'process_high'
container 'ghcr.io/bf528/homer_samtools:latest'
publishDir "${params.outdir}/tags", mode:'copy'

input:
tuple val(sample), path(bam)

output:
tuple val(sample), path("${sample}_tags")

script:
"""
makeTagDirectory ${sample}_tags ${bam}
"""

stub:
"""
mkdir ${sample}_tags
"""

}


