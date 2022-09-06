###########################################################
#                                                          #
# A snakefile to remove host contamination.                #
#                                                          #
# We have several versions of contamination removal        #
# this uses bowtie2.                                       #
#                                                          #
# For more information see this site:                      #
# https://edwards.sdsu.edu/research/command-line-deconseq/ #
#                                                          #
############################################################

import os
INTERIMDIR = "host_mapped"

rule host_indices:
    input:
        h=os.path.join(HOST, "{host}.fasta")
    params:
        basename=os.path.join(HOST, "{host}-index")
    conda:
        "../envs/bowtie.yaml"
    output:
        output1=os.path.join(HOST, "{host}-index.1.bt2"),
        output2=os.path.join(HOST, "{host}-index.2.bt2"),
        output3=os.path.join(HOST, "{host}-index.3.bt2"),
        output4=os.path.join(HOST, "{host}-index.4.bt2"),
        outputrev1=os.path.join(HOST, "{host}-index.rev.1.bt2"),
        outputrev2=os.path.join(HOST, "{host}-index.rev.2.bt2")
    shell:
        """
        bowtie2-build {input.h} {params.basename}
        """

rule btmap:
    input:
        r1 = os.path.join(PSEQDIR, "{sample}_good_out_R1.fastq.gz"),
        r2 = os.path.join(PSEQDIR, "{sample}_good_out_R2.fastq.gz"),
        s1 = os.path.join(PSEQDIR, "{sample}_single_out_R1.fastq.gz"),
        s2 = os.path.join(PSEQDIR, "{sample}_single_out_R2.fastq.gz"),
        un=os.path.join(HOST, "{host}-index.1.bt2")
    output:
        os.path.join(INTERIMDIR, '{sample}.hostmapped.bam')
    params:
        idx = os.path.join(HOST, "{host}-index")
    conda:
        "../envs/bowtie.yaml"
    threads: 16
    resources:
        mem_mb=64000,
    shell:
        """
		bowtie2 --mm -p {threads} -x {params.idx} -1 {input.r1} -2 {input.r2} \
         | samtools view -@ {threads} -bh | samtools sort -o {output} -
        """

rule R1_reads_map_to_ref:
    input:
        os.path.join(INTERIMDIR, '{sample}.hostmapped.bam')
    output:
        os.path.join(INTERIMDIR, "{sample}_R1_mapped_to_host.fastq")
    threads: 8
    resources:
        mem_mb=16000,
    conda:
        "../envs/bowtie.yaml"
    shell:
        "samtools fastq -@ {threads} -G 12 -f 65 {input} > {output}"

rule R2_reads_map_to_ref:
    input:
        os.path.join(INTERIMDIR, '{sample}.hostmapped.bam')
    output:
        os.path.join(INTERIMDIR, "{sample}_R2_mapped_to_host.fastq")
    threads: 8
    resources:
        mem_mb=16000,
    conda:
        "../envs/bowtie.yaml"
    shell:
        "samtools fastq -@ {threads} -G 12 -f 129 {input} > {output}"

rule single_reads_map_to_ref:
    input:
        os.path.join(INTERIMDIR, '{sample}.hostmapped.bam')
    output:
        os.path.join(INTERIMDIR, "{sample}_S_mapped_to_host.fastq")
    threads: 8
    resources:
        mem_mb=16000,
    conda:
        "../envs/bowtie.yaml"
    shell:
        "samtools fastq -@ {threads} -F 5 {input} > {output}"
        
rule R1_unmapped:
    input:
        os.path.join(INTERIMDIR, '{sample}.hostmapped.bam')
    output:
        os.path.join(PSEQDIR_TWO, "{sample}_good_out_R1.fastq"),
    threads: 8
    resources:
        mem_mb=16000,
    conda:
        "../envs/bowtie.yaml"
    shell:
        "samtools fastq -@ {threads} -f 77  {input} > {output}"

rule R2_unmapped:
    input:
        os.path.join(INTERIMDIR, '{sample}.hostmapped.bam')
    output:
        os.path.join(PSEQDIR_TWO, "{sample}_good_out_R2.fastq"),
    threads: 8
    resources:
        mem_mb=16000,
    conda:
        "../envs/bowtie.yaml"
    shell:
        "samtools fastq -@ {threads} -f 141 {input} > {output}"

rule single_reads_unmapped:
    input:
        os.path.join(INTERIMDIR, '{sample}.hostmapped.bam')
    output:
        s1 = os.path.join(PSEQDIR_TWO, "{sample}_single_out_R1.fastq"),
        s2 = os.path.join(PSEQDIR_TWO, "{sample}_single_out_R2.fastq")
    conda:
        "../envs/bowtie.yaml"
    threads: 8
    resources:
        mem_mb=16000,
    shell:
        """
        samtools fastq -@ {threads} -f 4 -F 1  {input} > {output.s1} &&
        touch {output.s2}
        """

rule compress_host_mapped_sequences:
    """
    Compress the host mapped data.
    I am not sure this rule is used!
    """
    input:
        os.path.join(INTERIMDIR, "{sample}_R1_mapped_to_host.fastq"),
        os.path.join(INTERIMDIR, "{sample}_R2_mapped_to_host.fastq"),
        os.path.join(INTERIMDIR, "{sample}_S_mapped_to_host.fastq"),
    output:
        os.path.join(INTERIMDIR, "{sample}_R1_mapped_to_host.fastq.gz"),
        os.path.join(INTERIMDIR, "{sample}_R2_mapped_to_host.fastq.gz"),
        os.path.join(INTERIMDIR, "{sample}_S_mapped_to_host.fastq.gz"),
    shell:
        """
        for F in {input}; do gzip $F; done
        """