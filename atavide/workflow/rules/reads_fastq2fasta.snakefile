"""

Rules for converting reads from fastq to fasta, so mmseqs2 easy-toxonomy can be run
"""

#mmseqs2 easy taxa can be run only on fasta reads so converting reads from fastq to fasta 

rule fastq2fasta:
    input:
        r1= os.path.join(QCDIR_TWO, "{sample}_good_out_R1.fastq"),
        r2= os.path.join(QCDIR_TWO, "{sample}_good_out_R2.fastq"),
    output:
        o1 = os.path.join(QCDIR_TWO, "{sample}_good_out_R1.fasta.gz"),
        o2 = os.path.join(QCDIR_TWO, "{sample}_good_out_R2.fasta.gz"),
    conda: "../envs/prinseq.yaml"
    params:
        script=config['fq2fa']
    threads: 16
    shell:
        """
            cat {input.r1} | {params.script} | gzip -1 - > {output.o1}
            cat {input.r2} | {params.script} | gzip -1 - > {output.o2}
        """