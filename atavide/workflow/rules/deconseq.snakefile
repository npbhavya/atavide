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

host_bt_index = os.path.join(config['host_dbpath'], config['host_dbname'])

# set this to the location where you would like the results
# written. We will make the directory if it doesn't exist
INTERIMDIR = os.path.join(config['output'], "host_mapped")


if not os.path.exists(host_bt_index + ".1.bt2") and not os.path.exists(host_bt_index + ".1.bt2l"):
    sys.stderr.write(f"ERROR: Could not find the bowtie2 indexes for {host_bt_index}\n")
    sys.stderr.write(f" - Did you build them with bowtie2-build?\n")
    sys.stderr.write(f" - You may need to edit `host_dbpath` and `host_dbname` in the snakefile config\n")
    sys.exit()


rule btmap:
    input:
        r1 = os.path.join(PSEQDIR, "{sample}_good_out_R1.fastq"),
        r2 = os.path.join(PSEQDIR, "{sample}_good_out_R2.fastq"),
        s1 = os.path.join(PSEQDIR, "{sample}_single_out_R1.fastq"),
        s2 = os.path.join(PSEQDIR, "{sample}_single_out_R2.fastq"),
    output:
        os.path.join(INTERIMDIR, '{sample}.hostmapped.bam')
    params:
        idx = host_bt_index
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