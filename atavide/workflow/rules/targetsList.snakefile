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
    ReadsAnnot.append(expand(os.path.join(QCDIR_TWO, "{sample}_good_out_R1.fasta.gz"), sample=SAMPLES))
    ReadsAnnot.append(expand(os.path.join(QCDIR_TWO, "{sample}_good_out_R2.fasta.gz"), sample=SAMPLES))
    ReadsAnnot.append(expand(os.path.join(RBADIR, "{sample}.taxonomy_report"), sample=SAMPLES))
    ReadsAnnot.append(expand(os.path.join(RBADIR, "{sample}.functions"), sample=SAMPLES))

Assembly=[]
if config['sequencing'] == 'paired':
   Assembly.append(expand(os.path.join(ASSEMBLY, "{sample}-megahit", "{sample}.contigs.fa"), sample=SAMPLES))
   Assembly.append(expand(os.path.join(ASSEMBLY, "{sample}-megahit", "{sample}.fastg"), sample=SAMPLES))