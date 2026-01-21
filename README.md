# RUNX1 ChIP-seq Analysis in Breast Cancer Cells

## Overview

This repository contains a reproducible **ChIP-seq analysis workflow** investigating the role of the transcription factor **RUNX1** in breast cancer cells. Using publicly available data from Barutcu et al. (2016), the project maps RUNX1 binding sites in MCF-7 cells, assesses reproducibility across biological replicates, and integrates ChIP-seq results with RNA-seq data to link RUNX1 chromatin binding to gene expression changes.

The workflow is implemented in **Nextflow** and executed in a containerized high-performance computing environment to ensure full reproducibility.

---

## Scientific Background

RUNX1 is a transcription factor with context-dependent roles in breast cancer, functioning as either a tumor suppressor or oncogene depending on cellular context. It interacts with chromatin regulators, estrogen receptor signaling, Polycomb complexes, and the nuclear matrix. Because breast cancer is associated with major alterations in nuclear organization, understanding how RUNX1 influences both transcriptional programs and chromatin structure is critical.

This project focuses on the ChIP-seq component of the original study, mapping RUNX1 binding sites and integrating these data with RNA-seq-derived differential expression results to identify direct regulatory relationships between RUNX1 binding and gene expression.

---

## Workflow Summary

### 1. Data Input

* ChIP-seq data from **MCF-7 breast cancer cells**
* Two biological replicates
* For each replicate:

  * RUNX1 ChIP (IP)
  * Corresponding INPUT control
* Total: 4 single-end FASTQ files

---

### 2. Quality Control & Preprocessing

* Initial read quality assessment using **FastQC v0.12.1**
* Adapter removal and quality trimming using **Trimmomatic v0.39**
* Aggregated QC reports generated with **MultiQC v1.25**

---

### 3. Alignment & Processing

* Reference genome indexing and alignment performed with **Bowtie2 v2.5.4** against hg38
* Conversion, sorting, and indexing of alignments using **SAMtools v1.21–1.17**
* Alignment statistics generated with `samtools flagstat`

---

### 4. Coverage & Reproducibility Analysis

* Normalized coverage tracks generated using **deepTools v3.5.5** `bamCoverage`
* Genome-wide signal correlation assessed using **deepTools** `multiBigwigSummary` and `plotCorrelation`
* Spearman correlation used to evaluate reproducibility between biological replicates

---

### 5. Peak Calling & Filtering

* Tag directory creation using **HOMER v4.11** `makeTagDirectory`
* Peak calling using **HOMER** `findPeaks` in factor mode (IP vs INPUT)
* Conversion of HOMER peak output to BED format
* Identification of reproducible peaks using **BEDtools v2.31.1**:

  * Peaks required to be present in all biological replicates
* Removal of peaks overlapping **ENCODE blacklist** regions to eliminate artifact-prone loci

---

### 6. Peak Annotation & Signal Profiling

* Genomic annotation of peaks using **HOMER** `annotatePeaks.pl`

  * Assignment to promoter, exon, intron, or intergenic regions
  * Distance to nearest transcription start site (TSS)
* Signal enrichment profiling across gene bodies using **deepTools** `computeMatrix` (scale-regions mode)

  * ±2000 bp padding around gene bodies
* Aggregate enrichment plots generated with `plotProfile`

---

### 7. Motif Discovery

* De novo motif enrichment analysis using **HOMER** `findMotifsGenome.pl`
* Motifs searched within ±200 bp of peak summits
* Size-matched genomic background used for enrichment testing

---

### 8. Integration with RNA-seq Data

* Integration with publicly available RNA-seq differential expression results (GEO: **GSE75070**)
* RNA-seq filtering criteria:

  * Adjusted p-value < 0.01
  * |log2 fold change| > 1
* Functional enrichment analysis performed using **ENRICHR v3.4**

  * Adjusted p-value < 0.05

---

## Visualization

* Coverage plots across gene bodies and specific loci (e.g., *MALAT1*, *NEAT1*)
* Correlation heatmaps and Venn diagrams for peak reproducibility
* Motif enrichment plots
* Functional enrichment plots highlighting RUNX1-associated pathways

Visualization and downstream analyses were performed using **Python v3.10.19** and **R v4.4.3**.

---

## Execution Environment

* Workflow manager: **Nextflow v25.04.6.5954**
* Execution platform: **Boston University Shared Computing Cluster (SCC)**
* Containerization: **Singularity**

All tools were executed with default parameters unless otherwise specified.

---

## Repository Contents

* Nextflow pipelines for ChIP-seq processing and analysis
* Configuration files for Singularity containers and cluster execution
* Scripts for reproducibility assessment, peak filtering, and integration analyses
* Visualization scripts and notebooks

---

## Outputs

* Trimmed and aligned BAM files
* Normalized bigWig coverage tracks
* Reproducible RUNX1 peak sets (BED) and genomic annotations
* Correlation, coverage, and Venn diagram plots
* Motif enrichment tables and figures
* Integrated ChIP-seq + RNA-seq results linking RUNX1 binding to gene expression changes

---

## Reproducibility

This project emphasizes reproducible epigenomics analysis through Nextflow-based workflows, containerized software environments, and explicit versioning of all tools. The pipeline can be rerun on any compatible system to generate identical results.

---

## Reference

Barutcu AR, Hong D, Lajoie BR, et al. *RUNX1 contributes to higher-order chromatin organization and gene regulation in breast cancer cells*. Biochim Biophys Acta. 2016;1859(11):1389–1397. doi:10.1016/j.bbagrm.2016.08.003
