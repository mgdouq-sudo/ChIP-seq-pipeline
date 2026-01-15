#!/usr/bin/env nextflow

process PLOTPROFILE {

    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir "${params.outdir}/plotProfile", mode: 'copy'

    
    input:
    
    path(matrix)

    output:

    path('*')

    script:
    """
    plotProfile -m $matrix -o singal_coverage.png
    """

    stub:
    """
    touch ${sample_id}_signal_coverage.png
    """
}