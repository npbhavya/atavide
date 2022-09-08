"""
Making a new directory and just copying QC results here 
"""

rule copyfiles:
    input:
        r1 = os.path.join(PSEQDIR, "{sample}_good_out_R1.fastq"),
        r2 = os.path.join(PSEQDIR, "{sample}_good_out_R2.fastq"),
        s1 = os.path.join(PSEQDIR, "{sample}_single_out_R1.fastq"),
        s2 = os.path.join(PSEQDIR, "{sample}_single_out_R2.fastq"),
    output:
        o1= os.path.join(PSEQDIR_TWO, "{sample}_good_out_R1.fastq"),
        o2= os.path.join(PSEQDIR_TWO, "{sample}_good_out_R2.fastq"),
        os1=os.path.join(PSEQDIR_TWO, "{sample}_single_out_R1.fastq"),
        os2=os.path.join(PSEQDIR_TWO, "{sample}_single_out_R2.fastq")
    params:
        odir= "PSEQDIR_TWO",
        indir = "PSEQDIR"
    shell:
        """
            rmdir {params.odir}
            mkdir {params.odir}
            cp -r {params.indir} {params.odir}
        """