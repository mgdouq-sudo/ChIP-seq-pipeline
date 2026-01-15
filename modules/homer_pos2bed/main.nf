#!/usr/bin/env nextflow

process POS2BED {

    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/pos2bed_full", mode:'copy'

    input:

    tuple val(rep), path(txt)

    output:

    tuple val(rep), path("${rep}.bed")

    script:
    """
    pos2bed.pl $txt > ${rep}.bed
    """
    stub:
    """
    touch ${rep}.bed
    """
}


