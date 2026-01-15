#!/usr/bin/env nextflow

process FINDPEAKS {
  
label 'process_high'
container 'ghcr.io/bf528/homer_samtools:latest'
publishDir "${params.outdir}/findpeaks_full", mode:'copy'

input:

tuple val(sample), path(rep)

output:

tuple val(sample), path("${sample}_peaks.txt")

script:
"""
findPeaks ${rep[1]} -style factor -o ${sample}_peaks.txt -i ${rep[0]}
"""

stub:
"""
touch ${sample}_peaks.txt
"""
}


