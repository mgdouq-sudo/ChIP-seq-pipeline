#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {

    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir "${params.outdir}/bedtools_intersect_full", mode:'copy'
    
    input:

    tuple val(reps), path(sortedbeds)

    output:

    path ("repr_peaks.bed")

    script:
    """
    bedtools intersect -a ${sortedbeds[0]} -b ${sortedbeds[1]} > repr_peaks.bed
    """

    stub:
    """
    touch repr_peaks.bed
    """
}