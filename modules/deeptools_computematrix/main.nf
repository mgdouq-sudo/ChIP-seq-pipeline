#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir "${params.outdir}/ComputeMatrix", mode: 'copy'

    input:
    path(bw)
    path(bed)

    output:
    path('*')

    script:
    """
    computeMatrix scale-regions -S $bw -R $bed -a 2000 -b 2000 -p 8 -o matrix.gz
    """

    stub:
    """
    touch ${sample}_matrix.gz
    """
}