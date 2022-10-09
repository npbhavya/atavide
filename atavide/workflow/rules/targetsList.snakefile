"""
Declare your targets here!
A separate file is ideal if you have lots of target files to create, or need some python logic to determine
the targets to declare. This example shows targets that are dependent on the input file type.
"""

"""TARGETS: Preprocess
Runs only the QC step
"""
preprocess=[]

if config['sequencing'] == 'paired':
    preprocess.append(os.path.join(STATS, "initial_read_statistics.tsv"))
    preprocess.append(expand(os.path.join(QCDIR, "{sample}_good_out_R1.fastq"), sample=SAMPLES))
    preprocess.append(expand(os.path.join(QCDIR, "{sample}_good_out_R2.fastq"), sample=SAMPLES))
    preprocess.append(expand(os.path.join(QCDIR_TWO, "{sample}_good_out_R1.fastq"),sample=SAMPLES))
    preprocess.append(expand(os.path.join(QCDIR_TWO, "{sample}_good_out_R2.fastq"),sample=SAMPLES))
    preprocess.append(os.path.join(STATS, "av_quality_scores_by_position.tsv"))
    #preprocess.append(os.path.join(STATS, "post_qc_statistics.tsv"))
elif config['sequencing'] == 'longread':
    preprocess.append(os.path.join(STATS, "initial_read_statistics.tsv"))
    preprocess.append(expand(os.path.join(QCDIR, "{sample}_filtlong.fastq"), sample=SAMPLES))
    preprocess.append(expand(os.path.join(QCDIR_TWO, "{sample}_filtlong.fastq"),sample=SAMPLES))
    preprocess.append(os.path.join(STATS, "av_quality_scores_by_position.tsv"))
    #preprocess.append(os.path.join(STATS, "post_qc_statistics.tsv"))

"""TARGETS: Reads annotations
After QC, runs the read annotations
If host removal performed then those reads are run through these steps
"""

ReadsAnnot=[]

if config['sequencing'] == 'paired':
    ReadsAnnot.append(os.path.join(STATS, "kraken_species_rarefaction.tsv"))
    ReadsAnnot.append(os.path.join(STATS, "kraken_species.tsv"))
    ReadsAnnot.append(os.path.join(STATS, "kraken_phyla.tsv"))
    ReadsAnnot.append(os.path.join(STATS, "kraken_families.tsv"))
    ReadsAnnot.append(os.path.join(STATS, "kraken_genera.tsv"))
    ReadsAnnot.append(expand(os.path.join(RBADIR, "{sample}", "superfocus", "output_all_levels_and_function.xls.zip"), sample=SAMPLES))
    ReadsAnnot.append(os.path.join(STATS, "superfocus_functions.tsv.gz"))

elif config['sequencing'] == 'longread':
    ReadsAnnot.append(os.path.join(STATS, "kraken_species_rarefaction.tsv"))
    ReadsAnnot.append(os.path.join(STATS, "kraken_species.tsv"))
    ReadsAnnot.append(os.path.join(STATS, "kraken_phyla.tsv"))
    ReadsAnnot.append(os.path.join(STATS, "kraken_families.tsv"))
    ReadsAnnot.append(os.path.join(STATS, "kraken_genera.tsv"))
    ReadsAnnot.append(os.path.join(STATS, "superfocus_functions.tsv.gz"))
