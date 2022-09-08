"""
This set of rules refines bins from metabat2, runs the bins through graphbin2
"""

rule graphbin:
    input:
        contigs = os.path.join(CCMO, "assembly.fasta"),
        graph = os.path.join(CCMO, "assembly_graph.gfa"),
        bins= os.path.join(METABAT, "metabat_depth")
    output:
        out = os.path.join(GRAPHBIN, "graphbin_output.csv")
    params:
        dir= GRAPHBIN
    conda: 
        "../envs/graphbin.yaml"
    shell:
        """
        graphbin --assembler flye --graph {input.graph} \
            --contigs {input.contigs} --binned {input.bins} \
            --output {params.dir}
        """