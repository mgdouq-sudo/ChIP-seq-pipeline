#!/usr/bin/env nextflow

process BEDTOOLS_SORT {

    label 'process_medium'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir "${params.outdir}/bedtools_sorted_full", mode:'copy'
    
    input:

    tuple val(rep), path(bed)

    output:
    
    tuple val(rep), path("${rep}.sorted.bed")

    script:
    """
    bedtools sort -i $bed > ${rep}.sorted.bed
    """

    stub:
    """
    touch ${rep}.sorted.bed
    """
}