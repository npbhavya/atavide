"""

Rules for reads functional annotation using mmseqs2 against Uniref50 database 
"""
rule mmseqs_annot:
    input:
        r1=os.path.join(QCDIR_TWO, "{sample}_good_out_R1.fasta.gz"),
        r2=os.path.join(QCDIR_TWO, "{sample}_good_out_R2.fasta.gz"),
    output:
        o=os.path.join(RBADIR, "{sample}.functions"),
    params:
        db=os.path.join('database', 'uniref50', 'UniRef50'),
        tmp="tmp",
        mem= '150G'
    conda:
        "../envs/mmseqs2.yaml"
    threads: 16
    resources:
        mem_mb=200000,
        time=7200,
    shell:
        """
            mmseqs easy-search {input.r1} {input.r2} {params.db} {output.o} {params.tmp} --threads {threads} --split-memory-limit {params.mem}
        """