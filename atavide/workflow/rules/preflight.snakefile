"""
Add your preflight checks as pure Python code here.
e.g. Configure the run, declare directories, validate the input files etc.
"""

"""CONFIGURATION
parsing the config to variables is not necessary, but it looks neater than typing out config["someParam"] every time.
"""
READDIR = config['input']
OUTDIR = config['output']
logs = os.path.join(OUTDIR,'logs')

""" CHECKING INPUT FILES
A Snakemake regular expression matching the forward mate FASTQ files.
"""
if config ['sequencing'] == 'paired':
    QCDIR = os.path.join(OUTDIR, 'prinseq')
    QCDIR_TWO = f"{QCDIR}_after_hostremoval"
    print(f"Illumina QC is run using prinseq, and the output files are saved to, {QCDIR}\n")
    SAMPLES,EXTENSIONS, = glob_wildcards(os.path.join(READDIR, '{sample}_R1{extn}'))
    if len(SAMPLES) == 0:
        sys.stderr.write(f"We did not find any fastq files in {SAMPLES}. Is this the right read dir?\n")
        sys.stderr.write(f"If the files are there, but running into an error, check filepaths\n")
        sys.exit(0)
    if len(set(EXTENSIONS)) != 1:
        sys.stderr.write("FATAL: You have more than one type of file extension\n\t")
        sys.stderr.write("\n\t".join(set(EXTENSIONS)))
        sys.stderr.write("\nWe don't know how to handle these\n")
        sys.exit(0)

    FQEXTN = EXTENSIONS[0]
    PATTERN_R1 = '{sample}_R1' + FQEXTN
    PATTERN_R2 = '{sample}_R2' + FQEXTN

elif config['sequencing'] == 'longread':
    QCDIR = os.path.join(OUTDIR, 'filtlong')
    QCDIR_TWO = f"{QCDIR}_after_hostremoval"    
    print(f"Nanopore fastq files run through QC using filtlong, the outputs are saved to, {QCDIR}\n")
    SAMPLES,EXTENSIONS, =glob_wildcards(os.path.join(READDIR, '{sample}.{extn}'))
    if len(SAMPLES) ==0:
        sys.stderr.write(f"We did not find any fastq files in {SAMPLES2}. Is this the right read dir?\n")
        sys.stderr.write(f"If the files are there, but running into an error, check filepaths\n")
        sys.exit(0)
    if len(set(EXTENSIONS)) != 1:
        sys.stderr.write("FATAL: You have more than one type of file extension\n\t")
        sys.stderr.write("\n\t".join(set(EXTENSIONS2)))
        sys.stderr.write("\nWe don't know how to handle these\n")
        sys.exit(0)


STATS   = os.path.join(config['output'], 'statistics')
TMPDIR  = os.path.join(config['output'], 'temp_directory')
RBADIR  = os.path.join(config['output'], 'read_based_annotations')

SAMPLE_ID=re.sub('\W+','', config['sample_id'])

"""SETTING PYTHONPATH
what is the directory of atavide.snakefile. We need to add that to the pythonpath and also use it for scripts
"""
ATAVIDE_DIR = workflow.basedir
# append to pythonpath
sys.path.append(ATAVIDE_DIR)

""" DATABASE PATHS
Setting the taxonomy database 
"""
TAXON = None
if (config['customDatabaseDirectory']):
   TAXON= os.path.join(config['customDatabaseDirectory'], "taxdump")
elif 'NCBI_TAXONOMY' in os.environ:
    TAXON = os.environ['NCBI_TAXONOMY']
else:
    sys.stderr.write("FATAL: NCBI taxonomy database not installed, run 'atavide install'\n")
    sys.exit(1)

#Where is the superfocus database?
SFDB = None
if (config['customDatabaseDirectory']):
    SFDB = os.path.join(config['customDatabaseDirectory'], 'superfocus_mmseqsDB', 'mmseqs2')
elif 'SUPERFOCUS_DB' in os.environ:
    SFDB = os.environ['SUPERFOCUS_DB']
else:
    sys.stderr.write("FATAL: Superfocus database not installed, run 'atavide install'\n")
    sys.exit(1)

#Setting krakendb variable
KRKNDB = None
if (config['customDatabaseDirectory']):
    KRKNDB = os.path.join(config['customDatabaseDirectory'], 'kraken2db')
elif 'KRAKEN2_DB_PATH' in os.environ:
    KRKNDB= os.environ['KRAKEN2_DB_PATH']
else:
    sys.stderr.write("FATAL: Kraken2 database not installed, run 'atavide install'\n")
    sys.exit(1)


""" Checking host contamination reference files
For host contamination removal, the user has to provide their own database of sequences (fasta files) 
Checking here to make sure we can find this file 
"""
if config['customHostDirectory']:
    print("Running host removal step since the paths are set")
    HOST=config['customHostDirectory']
    if not config['host_dbname']:
        sys.stderr.write(f"ERROR: You have set host_dbpath as {config['host_dbpath']} but haven't defined the bowtie2 index name\n")
        sys.stderr.write(f"Set the host_dbname variable with the bowtie2 index name in config.yaml file\n")
        sys.exit(0)
   
    bt2l = os.path.join(config['customHostDirectory'], f"{config['host_dbname']}.1.bt2l")
    bt2r = os.path.join(config['customHostDirectory'], f"{config['host_dbname']}.1.bt2")

    if not os.path.exists(bt2r) or os.path.exists(bt2l):
        sys.stderr.write(f"Error: don't seem to be able to find a bowtie2 index for {config['host_dbname']}\n")
        sys.stderr.write(f"\tWe looked for {bt2r} and {bt2l}\n")
        sys.exit(0)
else:
    print("Skipping host removal step since the paths aren't set")
