""" 
Currently a dump file with rules that I am not running or is breaking something else
"""

rule compress_prinseq:
    """
    Here we compress the prinseq files, but we also have as input
    the output of some of the other rules to make sure we don't 
    compress too early!
    """
    input:
        os.path.join(PSEQDIR, "{sample}_good_out_R1.fastq"),
        os.path.join(PSEQDIR, "{sample}_good_out_R2.fastq"),
        os.path.join(PSEQDIR, "{sample}_single_out_R1.fastq"),
        os.path.join(PSEQDIR, "{sample}_single_out_R2.fastq"),
        #os.path.join(RMRD, "{sample}_rpkm.tsv"),
        #os.path.join(RBADIR, "{sample}", "focus", "output_All_levels.csv.zip"),
        #os.path.join(STATS, "kraken_species_rarefaction.tsv"),
        #os.path.join(RBADIR, "{sample}", "superfocus", "output_all_levels_and_function.xls.zip"),
        #os.path.join(RBADIR, "{sample}", "singlem", "singlem_otu_table.tsv"),
        #os.path.join(STATS, "av_quality_scores_by_position.tsv")
    output:
        r1 = os.path.join(PSEQDIR, "{sample}_good_out_R1.fastq.gz"),
        r2 = os.path.join(PSEQDIR, "{sample}_good_out_R2.fastq.gz"),
        s1 = os.path.join(PSEQDIR, "{sample}_single_out_R1.fastq.gz"),
        s2 = os.path.join(PSEQDIR, "{sample}_single_out_R2.fastq.gz"),
    shell:
        """
        for F in {input}; do gzip -c $F > $F.gz; done
        """