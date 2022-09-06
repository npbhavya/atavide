"""
Declare your targets here!
A separate file is ideal if you have lots of target files to create, or need some python logic to determine
the targets to declare. This example shows targets that are dependent on the input file type.
"""

"""TARGETS: Preprocess
Runs only the QC step
"""
preprocess=[]

preprocess.append(expand(os.path.join(PSEQDIR, "{sample}_good_out_R1.fastq.gz"),sample=SAMPLES))