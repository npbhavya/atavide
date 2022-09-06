"""
Add your preflight checks as pure Python code here.
e.g. Configure the run, declare directories, validate the input files etc.
"""


"""CONFIGURATION
parsing the config to variables is not necessary, but it looks neater than typing out config["someParam"] every time.
"""
READDIR = config['input']
PSEQDIR = os.path.join(config['output'], config['directories']['prinseq'])
STATS   = os.path.join(config['output'], config['directories']['statistics'])
TMPDIR  = os.path.join(config['output'], config['directories']['temp_directory'])
RBADIR  = os.path.join(config['output'], config['directories']['read_based_annotations'])
METABAT = os.path.join(config['output'], config['directories']['binning'], 'metabat')
CONCOCT = os.path.join(config['output'], config['directories']['binning'], 'concoct')
ATAVIDE_BINNING = os.path.join(config['output'], config['directories']['binning'], 'atavide')

# assembly directories
ASSDIR  = os.path.join(config['output'], config['directories']['assemblies'], "assembly.1")
CRMDIR  = os.path.join(config['output'], config['directories']['assemblies'], "reads.contigs.1")
UNASSM  = os.path.join(config['output'], config['directories']['assemblies'], "unassembled_reads")
REASSM  = os.path.join(config['output'], config['directories']['assemblies'], "reassembled_reads")
CCMO    = os.path.join(config['output'], config['directories']['assemblies'], "final.combined_contigs")
RMRD    = os.path.join(config['output'], config['directories']['assemblies'], "reads_vs_final_assemblies")

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
   TAXON= os.path.join(config['customDatabaseDirectory'], "taxdump.tar.gz")
elif 'NCBI_TAXONOMY' in os.environ:
    TAXON = os.environ['NCBI_TAXONOMY']
else:
    sys.stderr.write("FATAL: NCBI taxonomy database not installed, run 'atavide install'\n")
    sys.exit(1)

#Where is the superfocus database?
SFDB  = None
if (config['customDatabaseDirectory']):
    SFDB = os.path.join(config['customDatabaseDirectory'], "superfocus_db")
elif 'SUPERFOCUS_DB' in os.environ:
    SFDB = os.environ['SUPERFOCUS_DB']
else:
    sys.stderr.write("FATAL: Superfocus database not installed, run 'atavide install'\n")
    sys.exit(1)

""" CHECKING INPUT FILES
A Snakemake regular expression matching the forward mate FASTQ files.
"""
# the comma after SAMPLES is important!
SAMPLES,EXTENSIONS, = glob_wildcards(os.path.join(READDIR, '{sample}_R1{extn}'))
if len(SAMPLES) == 0:
    sys.stderr.write(f"We did not find any fastq files in {SAMPLES}. Is this the right read dir?\n")
    sys.exit(0)
if len(set(EXTENSIONS)) != 1:
    sys.stderr.write("FATAL: You have more than one type of file extension\n\t")
    sys.stderr.write("\n\t".join(set(EXTENSIONS)))
    sys.stderr.write("\nWe don't know how to handle these\n")
    sys.exit(0)

FQEXTN = EXTENSIONS[0]
PATTERN_R1 = '{sample}_R1' + FQEXTN
PATTERN_R2 = '{sample}_R2' + FQEXTN
