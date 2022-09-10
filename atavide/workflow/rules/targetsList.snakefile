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
ReadsAnnot.append(os.path.join(STATS, "kraken_species_rarefaction.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_species.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_phyla.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_families.tsv"))
ReadsAnnot.append(os.path.join(STATS, "kraken_genera.tsv"))

"""TARGETS: Assembly 
After QC, runs assembly
If host removal performed then those reads are run through these steps
"""
assembly=[]
assembly.append(os.path.join(UNASSM, "R1.unassembled.fastq.gz"))
assembly.append(os.path.join(UNASSM, "R2.unassembled.fastq.gz"))
assembly.append(os.path.join(UNASSM, "single.unassembled.fastq.gz"))
assembly.append(os.path.join(REASSM, "merged_contigs.fa"))
assembly.append(os.path.join(CCMO, "assembly.fasta"))
assembly.append(os.path.join(STATS, "final_assembly.txt"))
assembly.append(os.path.join(STATS, "sample_coverage.tsv"))
assembly.append(os.path.join(STATS, "sample_rpkm.tsv"))
assembly.append(os.path.join(STATS, "sequence_lengths.tsv"))

"""TARGETS: Binning 
After QC, runs assembly, binning 
If host removal performed then those reads are run through these steps
"""
binning=[]
binning.append(os.path.join(METABAT, "metabat_depth"))
binning.append(os.path.join(METABAT, "metabat_bins/metabat_bins.1.fa"))
binning.append(os.path.join(GRAPHBIN, "graphbin_output.csv"))
