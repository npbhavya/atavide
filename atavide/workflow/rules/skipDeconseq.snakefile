
"""
Making a new directory and just copying QC results here 
"""

rule copyfiles:
    input:
        r1 = os.path.join(QCDIR, "{sample}_good_out_R1.fastq"),
        r2 = os.path.join(QCDIR, "{sample}_good_out_R2.fastq"),
        s1 = os.path.join(QCDIR, "{sample}_single_out_R1.fastq"),
        s2 = os.path.join(QCDIR, "{sample}_single_out_R2.fastq"),
    output:
        o1= os.path.join(QCDIR_TWO, "{sample}_good_out_R1.fastq"),
        o2= os.path.join(QCDIR_TWO, "{sample}_good_out_R2.fastq"),
        os1=os.path.join(QCDIR_TWO, "{sample}_single_out_R1.fastq"),
        os2=os.path.join(QCDIR_TWO, "{sample}_single_out_R2.fastq")
    params:
        odir= "QCDIR+TWO",
        indir = "QCDIR"
    shell:
        """
            cp -r {input.r1} {output.o1}
            cp -r {input.r2} {output.o2}
            cp -r {input.s1} {output.os1}
            cp -r {input.s2} {output.os2}
        """