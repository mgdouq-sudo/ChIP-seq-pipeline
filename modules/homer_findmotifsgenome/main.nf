#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {

label 'process_high'
container 'ghcr.io/bf528/homer_samtools:latest'
publishDir "${params.outdir}/findmotifs", mode:'copy'

input:

path(peaks)
path(genome)

output:

path('motifs')

script:
"""
findMotifsGenome.pl $peaks $genome motifs -size 200 -mask -p $task.cpus
"""

stub:
"""
mkdir motifs
"""
}


