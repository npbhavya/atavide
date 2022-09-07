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

"""TARGETS"""
allDatabaseFiles = []
allDatabaseFiles.append(os.path.join(databaseDir, config['ncbi_file']))
allDatabaseFiles.append(os.path.join(databaseDir, 'kraken', config['krakendb']))
allDatabaseFiles.append(os.path.join(databaseDir, 'superfocus_mmseqsDB', 'mmseqs.zip'))


"""RUN SNAKEMAKE"""
rule all:
    input:
        allDatabaseFiles

"""RULES"""
rule download_taxadb_file:
    params:
        ncbi =os.path.join(config['ncbi'], config['ncbi_file'])
    output:
        os.path.join(databaseDir, config['ncbi_file'])
    shell:
        """
            curl -Lo {output} {params.ncbi}
            unzip {output}
        """
        
rule download_krakendb_file:
    params:
        kraken =os.path.join(config['kraken2db_standard'], config['krakendb'])
    output:
        dir=os.path.join(databaseDir, 'kraken', config['krakendb'])
    shell:
        """
            curl -Lo {output.dir} {params.kraken}
            tar -xvzf {output.dir}
        """

rule download_superfocus_file:
    params:
        superfocus =os.path.join(config['superfocusdb_mmseqs2'])
    output:
        os.path.join(databaseDir, 'superfocus_mmseqsDB', 'mmseqsDB.zip')
    shell:
        """
            curl -Lo {output} {params.superfocus}
            unzip {output}
        """