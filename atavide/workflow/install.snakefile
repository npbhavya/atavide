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
allDatabaseFiles.append(os.path.join(hostDir, 'human', 'GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bowtie_index.1.bt2'))
allDatabaseFiles.append(os.path.join('database', 'uniref50', 'latest','version'))

"""RUN SNAKEMAKE"""
rule all:
    input:
        allDatabaseFiles

"""RULES"""
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

rule uniref:
    params:
        files=os.path.join('database', 'uniref50')
    output:
        o=os.path.join('database', 'uniref50', 'latest', 'version')
    conda:
        "envs/mmseqs2.yaml"
    shell:
        """
            mmseqs databases UniRef50 uniref50 {params.files}
        """    

