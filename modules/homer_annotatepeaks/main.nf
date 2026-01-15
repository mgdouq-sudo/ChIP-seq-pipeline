#!/usr/bin/env nextflow

process ANNOTATE {

    label 'process_high'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/homer_annotated_full", mode:'copy'

    input:

    path(filtered)
    path(genome)
    path(gtf)

    output:

    path("annotated_peaks.txt")

    script:
    """
    annotatePeaks.pl $filtered $genome -gtf $gtf > annotated_peaks.txt
    """
    stub:
    """
    touch annotated_peaks.txt
    """
}



