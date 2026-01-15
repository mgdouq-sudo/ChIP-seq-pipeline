// Include your modules here
include {FASTQC} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {MULTIQC} from './modules/multiqc'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {MULTIBWSUMMARY} from './modules/deeptools_multibwsummary'
include {PLOTCORRELATION} from './modules/deeptools_plotcorrelation'
include {TAGDIR} from './modules/homer_maketagdir'
include {FINDPEAKS} from './modules/homer_findpeaks'
include {POS2BED} from './modules/homer_pos2bed'
include {BEDTOOLS_SORT} from './modules/bedtools_sort'
include {BEDTOOLS_INTERSECT} from './modules/bedtools_intersect'
include {BEDTOOLS_REMOVE} from './modules/bedtools_remove'
include {ANNOTATE} from './modules/homer_annotatepeaks'
include {COMPUTEMATRIX} from './modules/deeptools_computematrix'
include {PLOTPROFILE} from './modules/deeptools_plotprofile'
include {FIND_MOTIFS_GENOME} from './modules/homer_findmotifsgenome'

workflow {

    
    //Here we construct the initial channels we need
    
    Channel.fromPath(params.samplesheet)
    | splitCsv( header: true )
    | map{ row -> tuple(row.name, file(row.path)) }
    | set { read_ch }

    FASTQC(read_ch)
    read_ch.view()
    TRIM(read_ch, params.adapter_fa)
    BOWTIE2_BUILD(params.genome)
    BOWTIE2_ALIGN(TRIM.out.gz, BOWTIE2_BUILD.out)
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out)
    SAMTOOLS_IDX(SAMTOOLS_SORT.out)
    SAMTOOLS_FLAGSTAT(BOWTIE2_ALIGN.out) 

    FASTQC.out.zip.map { it[1] }.collect()
    | set { fastqc_ch }

    TRIM.out.log.map { it[1] }.collect()
    | set { trim_ch }

    SAMTOOLS_FLAGSTAT.out.map { it[1] }.collect()
    | set { flagstat_ch }

    fastqc_ch.mix(trim_ch).mix(flagstat_ch).flatten().collect()
    | set { multiqc_ch }

    MULTIQC(multiqc_ch)

    BAMCOVERAGE(SAMTOOLS_IDX.out)

    BAMCOVERAGE.out.map { sample, bw -> bw }.collect()
    | set { bw_ch }

    MULTIBWSUMMARY(bw_ch)

    PLOTCORRELATION(MULTIBWSUMMARY.out.npz)

    TAGDIR(BOWTIE2_ALIGN.out)
    | view()
    | set { tagdir_ch }


  tagdir_ch
    | map { sample_id, path -> 
       [(sample_id =~ /rep\d+/)[0], path]
     }
    | groupTuple()
    | map { rep, paths ->
    // Explicitly sort: INPUT first, then IP
    def input = paths.find { it.name.contains('INPUT') }
    def ip = paths.find { it.name.contains('IP') }
    [rep, [input, ip]]
    }   
    | view()
    | set { grouped_ch }

    FINDPEAKS(grouped_ch)
    POS2BED(FINDPEAKS.out)
    BEDTOOLS_SORT(POS2BED.out)

    BEDTOOLS_SORT.out.map { rep, bed -> bed }  // Extract just the BED files
    .collect()  // Collect all into a list
    | view()
    | map { beds -> tuple("all_reps", beds) }  // Create tuple for intersect
    | view()
    | set { sorted_for_intersect }

    BEDTOOLS_INTERSECT(sorted_for_intersect)
    BEDTOOLS_REMOVE(BEDTOOLS_INTERSECT.out, params.blacklist)
    ANNOTATE(BEDTOOLS_REMOVE.out, params.genome, params.gtf)

    BAMCOVERAGE.out.filter { sample, bw -> sample.contains('IP') || sample.contains('ip') }
    | map { sample, bw -> bw }
    | set { ipbw_ch }

    COMPUTEMATRIX(ipbw_ch.collect(), params.ucsc_genes)
    PLOTPROFILE(COMPUTEMATRIX.out)
    FIND_MOTIFS_GENOME(BEDTOOLS_REMOVE.out, params.genome)

}