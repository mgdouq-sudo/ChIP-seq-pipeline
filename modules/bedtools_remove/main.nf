#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {

    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir "${params.outdir}/intersect_filtered_full", mode:'copy'
   
    input:

    path(intersect)
    path(blacklist)

    output:

    path("repr_peaks_filtered.bed")

    script:
    """
    bedtools intersect -a ${intersect} -b ${blacklist} -v > repr_peaks_filtered.bed
    """
    stub:
    """
    touch repr_peaks_filtered.bed
    """
}