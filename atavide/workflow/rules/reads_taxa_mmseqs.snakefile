"""

Rules for reads taxonomic annotation using mmseqs2 against Uniref50 database 
"""

rule mmseqs_taxa:
    input:
        r1=os.path.join(QCDIR_TWO, "{sample}_good_out_R1.fasta.gz"),
        r2=os.path.join(QCDIR_TWO, "{sample}_good_out_R2.fasta.gz"),
    output:
        o=os.path.join(RBADIR, "{sample}.taxonomy-report"),
    params:
        db=os.path.join('database', 'uniref50', 'UniRef50'),
        tmp= 'tmp',
        mem= '150G',
        o=os.path.join(RBADIR, "{sample}.taxonomy")
    conda:
        "../envs/mmseqs2.yaml"
    threads: 32
    resources:
        mem_mb=200000,
        time=7200,
    shell:
        """
            mmseqs easy-taxonomy {input.r1} {input.r2} {params.db} {params.o} {params.tmp} -s 7 --threads {threads} --split-memory-limit {params.mem}
        """