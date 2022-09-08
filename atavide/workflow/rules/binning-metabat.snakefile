"""
This set of rules handles the binning of reads using metabat

"""

import os
import sys
import socket

rule metabat_contigs_depth:
    input:
        bam = expand(os.path.join(RMRD, "{sample}." + SAMPLE_ID + ".assembly.bam"), sample=SAMPLES),
        bai = expand(os.path.join(RMRD, "{sample}." + SAMPLE_ID + ".assembly.bam.bai"), sample=SAMPLES),
        contigs = os.path.join(CCMO, "assembly.fasta")
    output:
        depth=os.path.join(METABAT, "metabat_depth")
    params:
        basename=os.path.join(METABAT, "metabat_bins")
    conda:
        "../envs/metabat2.yaml"
    shell:
        """
        mkdir --parents {params.basename};
        jgi_summarize_bam_contig_depths --outputDepth {output.depth} {input.bam}
        """

rule metabat_bins:
    input:
        contigs = os.path.join(config['directories']['assemblies'], f"{SAMPLE_ID}_assembly.fasta"),
        depth= os.path.join(METABAT, "metabat_depth")
    output:
        o=os.path.join(METABAT, "metabat_bins/metabat_bins.1.fa")
    params:
        base=os.path.join(METABAT, "metabat_bins/metabat_bins")
    conda:
        "../envs/metabat2.yaml"
    threads: 16
    resources:
        mem_mb=20000,
    shell:
        """
        touch {output}
        metabat2 -i {input.contigs} -a {input.depth} -m 1500 -o {params.base} -t {threads}
        """