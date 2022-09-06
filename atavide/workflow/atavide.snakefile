"""
A metagenome assembly pipeline written by Rob Edwards, Jan 2020-Jan 2022.

The idea is to start with pairs of reads and assemble those, and then 
combine all the assembled contigs and dereplicate using mmseqs, then 
map reads using bowtie2, and take the unmapped reads and reassemble.

Repeat that with the site data sets and then again with the sample
datasets.

To run on this command on HPC with slurm job scheduler:
atavide run --input test-data --profile slurm
"""

"""PREFLIGHT CHECKS
Validate your inputs, set up directories, parse your config, etc.
# Moved the file checks to "rules/filechecks.snakefile"
"""
include: "rules/filechecks.snakefile"

""" OLD CODE 
# how much memory do we have
#LARGE_MEM = config['parameters']['large_mem']

# how many reads do we want to subsample for superfocus?
#superfocus_subsample_reads = 0
#if 'superfocus_reads' in config['parameters']:
#    superfocus_subsample_reads = config['parameters']['superfocus_reads']
"""

""" TARGETS
Declare your targets, either here, or in a separate file.
"""
include: "rules/targetsList.snakefile"


# read the rules for running different pieces and parts of the code
include: "rules/qc_qa.snakefile"
include: "rules/deconseq.snakefile"

rule all:
    input:
        preprocess,
        contamination

rule QC:
    input:
        preprocess

rule HostRemoval:
    input:
        contamination

"""
include: "rules/focus.snakefile"
include: "rules/superfocus.snakefile"
include: "rules/round1_assembly.snakefile"
include: "rules/compress_outputs.snakefile"
include: "rules/round2_assembly.snakefile"
include: "rules/statistics.snakefile"
include: "rules/binning.snakefile"
include: "rules/kraken_taxonomy.snakefile"
include: "rules/kraken_rarefaction.snakefile"
include: "rules/singlem.snakefile"
include: "rules/combine_read_annotations.snakefile"
include: "rules/atavide_clusters.snakefile"
include: "rules/fqchk.snakefile"

localrules: all

rule all:
    input:
        expand(
            [
                os.path.join(PSEQDIR_TWO, "{sample}_good_out_R1.fastq.gz"),
                os.path.join(RBADIR, "{sample}", "focus", "output_All_levels.csv.zip"),
                os.path.join(RBADIR, "{sample}", "superfocus", "output_all_levels_and_function.xls.zip"),
                os.path.join(RBADIR, "{sample}", "superfocus", "{sample}_good_out_R1.taxonomy.zip"),
                os.path.join(RBADIR, "{sample}", "kraken", "{sample}.report.tsv.zip"),
                os.path.join(RBADIR, "{sample}", "kraken", "{sample}.output.tsv.zip"),
                os.path.join(RBADIR, "{sample}", "kraken", "{sample}.taxonomy.tsv.zip"), 
                os.path.join(RBADIR, "{sample}", "singlem", "singlem_otu_table.tsv.zip"),
                os.path.join(RMRD, "{sample}." + SAMPLE_ID + ".assembly.bam.bai"),
                os.path.join(RBADIR, "{sample}", "{sample}_contig_taxonomy.comparison.tsv.zip")
            ],
               sample=SAMPLES),
        os.path.join(REASSM, "merged_contigs.fa"),
        os.path.join(CCMO, "flye.log"),
        os.path.join(STATS, "post_qc_statistics.tsv"),
        os.path.join(STATS, "initial_read_statistics.tsv"),
        os.path.join(STATS, "final_assembly.txt.zip"),
        os.path.join(STATS, "sample_coverage.tsv.zip"),
        os.path.join(STATS, "sample_rpkm.tsv"),
        os.path.join(RBADIR, "superfocus_functions.tsv.gz"),
        os.path.join(STATS, "av_quality_scores_by_position.tsv"),
        os.path.join(STATS, "kraken_species_rarefaction.tsv"),
        os.path.join(STATS, "kraken_species.tsv"),
        os.path.join(STATS, "kraken_phyla.tsv"),
        os.path.join(STATS, "kraken_families.tsv"),
        os.path.join(STATS, "kraken_genera.tsv"),
        os.path.join(METABAT, "metabat_depth"),
        os.path.join(METABAT, "metabat_bins/metabat_bins.1.fa"),
        os.path.join(CONCOCT, "concoct_output/clustering_gt1000.csv"),
        os.path.join(CONCOCT, "concoct_bins/1.fa"),
        os.path.join(ATAVIDE_BINNING, "stats", "sample_coverage.h5"),
        os.path.join(ATAVIDE_BINNING, "stats", "atavide_clusters.json"),
        os.path.join(ATAVIDE_BINNING, "bins"),


"""