
"""
Making a new directory and just copying QC results here 
"""

rule copyfiles:
    input:
        r1 = os.path.join(QCDIR, "{sample}_filtlong.fastq"),
    output:
        o1= os.path.join(QCDIR_TWO, "{sample}_filtlong.fastq"),
    params:
        odir= "QCDIR_TWO",
        indir = "QCDIR"
    shell:
        """
            cp -r {input.r1} {output.o1}
        """
