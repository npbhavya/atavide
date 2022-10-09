"""
This is an auxiliary Snakefile to install databases.
"""


"""CONFIGURATION"""
configfile: os.path.join(workflow.basedir, '../', 'config', 'config.yaml')
configfile: os.path.join(workflow.basedir, '../', 'config', 'databases.yaml')


"""CHECK IF CUSTOM DATABASE DIRECTORY"""
if config['customDatabaseDirectory'] is None:
    databaseDir = os.path.join(workflow.basedir, 'database')
else:
    databaseDir = config['customDatabaseDirectory']
DATABASES = config['customDatabaseDirectory']

"""CHECK IF CUSTOM HOST DATABASE DIRECTORY"""
if config['customHostDirectory'] is None:
    hostDir = os.path.join(workflow.basedir, 'host')
else:
    hostDir = config['customHostDirectory']
HOST = config['customHostDirectory']

"""TARGETS"""
allDatabaseFiles = []
allDatabaseFiles.append(os.path.join(databaseDir, 'taxdump', config['ncbi_file']))
allDatabaseFiles.append(os.path.join(databaseDir, 'kraken2db', 'hash.k2d'))
allDatabaseFiles.append(os.path.join(databaseDir, 'superfocus_mmseqsDB/superfocus_mmseqsDB/mmseqs2/db/static/mmseqs2/90_clusters.db'))
allDatabaseFiles.append(os.path.join(hostDir, 'human', 'GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bowtie_index.1.bt2'))


"""RUN SNAKEMAKE"""
rule all:
    input:
        allDatabaseFiles

"""RULES"""
rule download_taxadb_file:
    params:
        ncbi =os.path.join(config['ncbi'], config['ncbi_file']),
        files=os.path.join(databaseDir, 'taxdump')
    output:
        os.path.join(databaseDir, 'taxdump', config['ncbi_file'])
    shell:
        """
            curl -Lo {output} {params.ncbi}
            tar -xvzf {output} -C {params.files}
        """
        
rule download_krakendb_file:
    params:
        kraken =config['kraken2'],
        db= os.path.join(databaseDir, 'kraken2db.tar.gz')
    output:
        dir=os.path.join(databaseDir, 'kraken2db'),
        o=os.path.join(databaseDir, 'kraken2db', 'hash.k2d')
    shell:
        """
            curl -Lo {params.db} {params.kraken}
            rm -rf {output.dir}
            mkdir {output.dir}
            tar -xvzf {params.db} -C {output.dir}
        """

rule download_superfocus_file:
    params:
        superfocus =config['superfocusdb_mmseqs2']
    output:
        o=os.path.join(databaseDir, 'superfocus_mmseqsDB.tar.gz'),
        out=os.path.join(databaseDir, 'superfocus_mmseqsDB'),
        finals=os.path.join(databaseDir, 'superfocus_mmseqsDB/superfocus_mmseqsDB/mmseqs2/db/static/mmseqs2/90_clusters.db')
    shell:
        """
            curl -Lo {output.o} {params.superfocus}
            tar -xvf {output.o} -C {output.out}
        """

rule human_download:
    params:
        download=config['human'],
        files=os.path.join(hostDir, 'human')
    output:
        out=os.path.join(hostDir, 'GCA_000001405.15_GRCh38_full_analysis_set.fna.bowtie_index.tar.gz'),
        o=os.path.join(hostDir, 'human', 'GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bowtie_index.1.bt2')
    shell:
        """
            curl -Lo {output.out} {params.download}
            rm -rf {params.files}
            mkdir {params.files}
            tar -xvzf {output.out} -C {params.files}
        """