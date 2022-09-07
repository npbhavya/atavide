"""
Declare your targets here!
A separate file is ideal if you have lots of target files to create, or need some python logic to determine
the targets to declare. This example shows targets that are dependent on the input file type.
"""

"""TARGETS: Preprocess
Runs only the QC step
"""
preprocess=[]
preprocess.append(expand(os.path.join(PSEQDIR, "{sample}_good_out_R1.fastq"),sample=SAMPLES))

"""TARGETS: Host contamination
After QC, runs the hostcontamination
"""
contamination=[]
contamination.append(expand(os.path.join(PSEQDIR_TWO, "{sample}_good_out_R1.fastq"),sample=SAMPLES))
contamination.append(expand(os.path.join(PSEQDIR_TWO, "{sample}_good_out_R2.fastq"), sample=SAMPLES))

"""TARGETS: Reads annotations
After QC, runs the read annotations
If host removal performed then those reads are run through these steps
"""
ReadsAnnot=[]
ReadsAnnot.append(expand(os.path.join(RBADIR, "{sample}", "kraken", "{sample}.report.tsv"), sample=SAMPLES))
ReadsAnnot.append(expand(os.path.join(RBADIR, "{sample}", "kraken", "{sample}.output.tsv"), sample=SAMPLES))
ReadsAnnot.append(expand(os.path.join(RBADIR, "{sample}", "kraken", "{sample}.taxonomy.tsv"), sample=SAMPLES))
ReadsAnnot.append(os.path.join(STATS, "kraken_species_rarefaction.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_species.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_phyla.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_families.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_genera.tsv"))