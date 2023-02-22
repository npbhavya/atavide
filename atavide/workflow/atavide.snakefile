"""
A metagenome assembly pipeline written by Rob Edwards, Jan 2020-Jan 2022.

The idea is to start with pairs of reads and assemble those, and then 
combine all the assembled contigs and dereplicate using mmseqs, then 
map reads using bowtie2, and take the unmapped reads and reassemble.

Repeat that with the site data sets and then again with the sample
datasets.

To run on this command on HPC with slurm job scheduler:
atavide reads --input test-data --profile slurm
"""


configfile: os.path.join(workflow.basedir, '..', 'config', 'config.yaml')


"""PREFLIGHT CHECKS
Validate your inputs, set up directories, parse your config, etc.
# Moved the file checks to "rules/filechecks.snakefile"
"""
include: "rules/preflight.snakefile"

include: "rules/targetsList.snakefile"

# read the rules for running different pieces and parts of the code
if config ['sequencing'] == 'paired':
    include: "rules/qc_qa.snakefile"

    if config['customHostDirectory']:
        include: "rules/deconseq.snakefile"
    else:
        include: "rules/skipDeconseq.snakefile"
    include: "rules/fqchk.snakefile"
    inlcude: "rules/statistics.snakefile"

    #Reads annotation rules
    include: "rules/reads_fastq2fasta.snakefile"
    include: "rules/reads_taxa_mmseqs.snakefile"
    include: "rules/reads_annot_mmseqs.snakefile"

    #assembly rules 
    include: "rules/assembly_megahit.snakefile"

elif config['sequencing'] == 'longread':
    include: "rules/qc_qa_minion.snakefile"

    if config['customHostDirectory']:
        include: "rules/deconseq_minion.snakefile"
    else:
        include: "rules/skipDeconseq_minion.snakefile"
    include: "rules/fqchk_minion.snakefile"
    inlcude: "rules/statistics-minion.snakefile"


"""
Attemping to make atavide modular
Current modules
1. QC : preprocessing with prinseq
2. HostRemoval: prepocessing with prinseq + removing reads that map to host
3. ReadAnnotations : taxa and functional annotation of preprocessed reads 

"""

rule all:
    input:
        preprocess,
        ReadsAnnot,
        Assembly