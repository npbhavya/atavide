"""

Rules for reads taxonomic annotation using mmseqs2 against Uniref50 database 
"""

#mmseqs2 easy taxa can be run only on fasta reads so converting reads from fastq to fasta 
rule fastq2fasta_r1:
    input:
        r1= os.path.join(QCDIR_TWO, "{sample}_good_out_R1.fastq"),
    output:
        o1= os.path.join(QCDIR_TWO, "{sample}_good_out_R1.fasta")
    shell:
        """
            ../scripts/fastq2fasta -r '_' -n 1
        """

rule fastq2fasta_r2:
    input:
        r1= os.path.join(QCDIR_TWO, "{sample}_good_out_R2.fastq"),
    output:
        o1= os.path.join(QCDIR_TWO, "{sample}_good_out_R2.fasta")
    shell:
        """
            ../scripts/fastq2fasta -r '_' -n 2
        """

rule mmseqs2-taxa-r1:
    input:
        r1=os.path.join(QCDIR_TWO, "{sample}_good_out_R1.fasta")
    output:
    


        