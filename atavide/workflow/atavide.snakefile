"""
A metagenome assembly pipeline written by Rob Edwards, Jan 2020-Jan 2022.

The idea is to start with pairs of reads and assemble those, and then 
combine all the assembled contigs and dereplicate using mmseqs, then 
map reads using bowtie2, and take the unmapped reads and reassemble.

Repeat that with the site data sets and then again with the sample
datasets.

To run on this command on HPC with slurm job scheduler:
atavide run --input test-data --profile slurm
"""


configfile: os.path.join(workflow.basedir, '..', 'config', 'config.yaml')


"""PREFLIGHT CHECKS
Validate your inputs, set up directories, parse your config, etc.
# Moved the file checks to "rules/filechecks.snakefile"
"""
include: "rules/filechecks.snakefile"

""" OLD CODE 
# how much memory do we have
#LARGE_MEM = config['parameters']['large_mem']

# how many reads do we want to subsample for superfocus?
#superfocus_subsample_reads = 0
#if 'superfocus_reads' in config['parameters']:
#    superfocus_subsample_reads = config['parameters']['superfocus_reads']
"""

""" TARGETS
Declare your targets, either here, or in a separate file.
"""
include: "rules/targetsList.snakefile"

# read the rules for running different pieces and parts of the code
include: "rules/qc_qa.snakefile"
include: "rules/fqchk.snakefile"

if config['host_dbpath']:
    include: "rules/deconseq.snakefile"
else:
    include: "rules/skipDeconseq.snakefile"

include: "rules/kraken_taxonomy.snakefile"
include: "rules/kraken_rarefaction.snakefile"
include: "rules/superfocus.snakefile"
include: "rules/round1_assembly.snakefile"

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
        assembly

rule QC:
    input:
        preprocess, contamination

rule ReadAnnotations:
    input:
        preprocess,
        ReadsAnnot

rule Assembly:
    input:
        preprocess, 
        assembly

