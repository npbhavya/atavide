"""

Rules for quality control and quality assurance
"""

rule input_read_stats:
    """
    Count the statistics for the initial sequences
    """
    input:
        fqdir = READDIR
    output:
        stats = os.path.join(STATS, "initial_read_statistics.tsv")
    script:
        "../scripts/countfastq.py"

"""
Rules for quality control and quality assurance - Nanopore fastq reads
"""

rule filtlong:
    input:
        i= os.path.join(READDIR, PATTERN)
    output:
        o= os.path.join(QCDIR, "{sample}_filtlong.fastq")
    conda: "../envs/filtlong.yaml"
    log:
        os.path.join(logs, "filtlong_{sample}.log")
    shell:
        """
            export LC_ALL=en_US.UTF-8
            filtlong --min_length 1000 --keep_percent 95 {input.i} > {output.o} 2> {log}
        """