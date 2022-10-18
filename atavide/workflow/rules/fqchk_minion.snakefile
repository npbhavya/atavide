# Use seqtk to summarize the fastq quality scores. We make a table that has reads
# and the average quality score at each position.
# This is run only for post-QC samples, if host path isn't added for host removal in the config file

INTERIMDIR = os.path.join(config['output'], "host_mapped")

rule fqchk_r1_sequences:
    input:
        r1 = os.path.join(QCDIR_TWO, "{sample}_filtlong.fastq")
    output:
        os.path.join(INTERIMDIR, "{sample}", "statistics", "{sample}_good_out_R1.fqchk.tsv")
    threads: 8
    resources:
        mem_mb=25000
    params:
        d =  os.path.join(INTERIMDIR, "{sample}", "statistics")
    conda:
        "../envs/seqtk.yaml"
    shell:
        """
        mkdir -p {params.d};
        seqtk fqchk {input.r1} > {output}
        """


rule get_fqchk_cols:
    input:
        os.path.join(INTERIMDIR, "{sample}", "statistics", "{sample}_good_out_R1.fqchk.tsv")
    output:
        temporary(os.path.join(INTERIMDIR, "{sample}", "statistics", "{sample}_good_out_R1.fqchk.tsv.tmp"))
    params:
        s = "{sample}"
    shell:
        """
        cut -f 1,8 {input} | tail -n +2 | grep -v ALL | sed -e 's/avgQ/{params.s}/' > {output}
        """


rule join_fqchk_cols:
    input:
        expand(os.path.join(INTERIMDIR, "{smp}", "statistics", "{smp}_good_out_R1.fqchk.tsv.tmp"), smp=SAMPLES)
    output:
        os.path.join(STATS, "av_quality_scores_by_position.tsv")
    params:
        sct = os.path.join(ATAVIDE_DIR, "scripts/joinlists.pl")
    shell:
        """
        perl {params.sct} -h {input} > {output}
        """

rule removing_dir:
    """
    Removing directories within QCDIR_TWO
    """
    params:
        os.path.join(INTERIMDIR, "{smp}")
    shell:
        """
        rmdir -rf {params}
        """

rule post_qc_stats:
    """
    Count the statistics after complete QC
    """
    input:
        fqdir = QCDIR_TWO
    params:
        fqdir = QCDIR_TWO
    output:
        stats = os.path.join(STATS, "post_qc_statistics.tsv")
    script:
        "../scripts/countfastq.py"