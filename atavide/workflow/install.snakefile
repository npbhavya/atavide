"""
This is an auxiliary Snakefile to install databases.
"""


"""CONFIGURATION"""
configfile: os.path.join(workflow.basedir, '../', 'config', 'config.yaml')
configfile: os.path.join(workflow.basedir, '../', 'config', 'databases.yaml')


""CHECK IF CUSTOM DATABASE DIRECTORY"""
if config['customDatabaseDirectory'] is None:
    databaseDir = os.path.join(workflow.basedir, 'databaseDir')
else:
    databaseDir = c"onfig['customDatabaseDirectory']
DATABASES = config['customDatabaseDirectory']
print(f"Databases are being saved in, {DATABASES} \n")


"""TARGETS"""
allDatabaseFiles = []
for file in config['databaseFiles']:
    allDatabaseFiles.append(os.path.join(databaseDir, file))


"""RUN SNAKEMAKE"""
rule all:
    input:
        allDatabaseFiles


"""RULES"""
rule download_db_file:
    """Generic rule to download a database file."""
    output:
        os.path.join(databaseDir, "{file}")
    params:
        mirror = config['mirror']
    run:
        import urllib.request
        import urllib.parse
        import shutil
        dlUrl1 = urllib.parse.urljoin(params.mirror, wildcards.file)
        dlUrl2 = urllib.parse.urljoin(params.mirror, wildcards.file)
        try:
            with urllib.request.urlopen(dlUrl1) as r, open(output[0],'wb') as o:
                shutil.copyfileobj(r,o)
        except:
            with urllib.request.urlopen(dlUrl2) as r, open(output[0],'wb') as o:
                shutil.copyfileobj(r,o)