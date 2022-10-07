"""
Declare your targets here!
A separate file is ideal if you have lots of target files to create, or need some python logic to determine
the targets to declare. This example shows targets that are dependent on the input file type.
"""

"""TARGETS: Preprocess
Runs only the QC step
"""
preprocess=[]
preprocess.append(os.path.join(STATS, "initial_read_statistics.tsv"))
preprocess.append(expand(os.path.join(PSEQDIR_TWO, "{sample}_good_out_R1.fastq"),sample=SAMPLES))
preprocess.append(os.path.join(STATS, "av_quality_scores_by_position.tsv"))
preprocess.append(os.path.join(STATS, "post_qc_statistics.tsv"))

"""TARGETS: Reads annotations
After QC, runs the read annotations
If host removal performed then those reads are run through these steps
"""
ReadsAnnot=[]
ReadsAnnot.append(expand(os.path.join(RBADIR, "{sample}", "superfocus", "output_all_levels_and_function.xls.zip"), sample=SAMPLES))
ReadsAnnot.append(expand(os.path.join(RBADIR, "{sample}", "superfocus", "{sample}_good_out_R1.taxonomy.zip"), sample=SAMPLES))
ReadsAnnot.append(expand(os.path.join(RBADIR, "{sample}", "kraken", "{sample}.report.{frac}.tsv"), sample=SAMPLES, frac=0.1))
ReadsAnnot.append(os.path.join(STATS, "kraken_species_rarefaction.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_species.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_phyla.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_families.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_genera.tsv"))
