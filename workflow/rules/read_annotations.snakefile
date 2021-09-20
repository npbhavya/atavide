"""

Snakemake rule to run several read-based annotation systems
including kraken, focus, super-focus and singlem.

For focus/superfocus we need a directory so we make hard links

For kraken and singlem

"""


import os
import sys

# TODO
# we have a database linked here: 
#       db = "/home/edwa0468/ncbi/taxonomy/taxonomy.sqlite3"
# and we need to do something with this!



# set this to whatever the name of your directory
# with the reads is. If you are following along with the
# tutorial, you can leave this as fastq
OUTDIR  = 'ReadAnnotations'

# this is left over from standalone code.
# PSEQDIR="QC"
# SAMPLES, = glob_wildcards(os.path.join(PSEQDIR, '{sample}_good_out_R1.fastq'))


# just check there is something to actually do!
if len(SAMPLES) == 0:
    sys.stderr.write("FATAL: We could not detect any samples at all.\n")
    sys.stderr.write(f"Do you have a directory called {PSEQDIR_TWO} with some fastq files in it?\n")
    sys.exit()


rule read_annotation_all:
    """
    This rule is probably not used unless you use this as a standalone snakemake script!
    """
    input:
        expand(
            [
                os.path.join(OUTDIR, "{sample}", "focus", "output_All_levels.csv"),
                os.path.join(OUTDIR, "{sample}", "superfocus", "output_all_levels_and_function.xls"),
                os.path.join(OUTDIR, "{sample}", "kraken", "{sample}.report.tsv"),
                os.path.join(OUTDIR, "{sample}", "singlem", "singlem_otu_table.tsv"),
                os.path.join(OUTDIR, "{sample}", "kraken", "{sample}.output.tsv"),
            ],
               sample=SAMPLES),
        os.path.join(OUTDIR, "all_taxonomy.tsv")



# focus/super-focus uses directories, and so if we point it at the whole prinseq
# directory it will process all the data in there.

# therefore, we make a new directory and link just the file we need. Doesn't consume
# any more space!

rule link_psq_good:
    input:
        r1 = os.path.join(PSEQDIR_TWO, "{sample}_good_out_R1.fastq")
    output:
        d = directory(os.path.join(OUTDIR, "{sample}", "prinseq_good")),
        f = os.path.join(OUTDIR, "{sample}", "prinseq_good", "{sample}.good_out_R1.fastq")
    params:
        d = os.path.join(OUTDIR, "{sample}", "prinseq_good")
    shell:
        """
        mkdir -p {params.d} && ln {input.r1} {output.f}
        """

rule run_focus:
    """
    Run focus on the directory with just the prinseq good R1 data
    """
    input:
        os.path.join(OUTDIR, "{sample}", "prinseq_good")
    output:
        d = directory(os.path.join(OUTDIR, "{sample}", "focus")),
        a = os.path.join(OUTDIR, "{sample}", "focus", "output_All_levels.csv"),
        f = temporary(os.path.join(OUTDIR, "{sample}", "focus", "output_Family_tabular.csv")),
        k = temporary(os.path.join(OUTDIR, "{sample}", "focus", "output_Kingdom_tabular.csv")),
        p = temporary(os.path.join(OUTDIR, "{sample}", "focus", "output_Phylum_tabular.csv")),
        s = temporary(os.path.join(OUTDIR, "{sample}", "focus", "output_Strain_tabular.csv")),
        c = temporary(os.path.join(OUTDIR, "{sample}", "focus", "output_Class_tabular.csv")),
        g = temporary(os.path.join(OUTDIR, "{sample}", "focus", "output_Genus_tabular.csv")),
        o = temporary(os.path.join(OUTDIR, "{sample}", "focus", "output_Order_tabular.csv")),
        sp = temporary(os.path.join(OUTDIR, "{sample}", "focus", "output_Species_tabular.csv"))
    resources:
        cpus=8,
        mem_mb=16000
    conda:
        "../envs/focus.yaml"
    shell:
        """
        focus -q {input} -o {output.d} -t {resources.cpus}
        """

# TODO
# We should remove the -b once the SUPERFOCUS_DB environment variable works

rule run_superfocus:
    input:
        os.path.join(OUTDIR, "{sample}", "prinseq_good")
    output:
        d = directory(os.path.join(OUTDIR, "{sample}", "superfocus")),
        a = os.path.join(OUTDIR, "{sample}", "superfocus", "output_all_levels_and_function.xls"),
        m8 = os.path.join(OUTDIR, "{sample}", "superfocus", "{sample}.good_out_R1.fastq_alignments.m8"),
        l1 = temporary(os.path.join(OUTDIR, "{sample}", "superfocus", "output_subsystem_level_1.xls")),
        l2 = temporary(os.path.join(OUTDIR, "{sample}", "superfocus", "output_subsystem_level_2.xls")),
        l3 = temporary(os.path.join(OUTDIR, "{sample}", "superfocus", "output_subsystem_level_3.xls")),
    resources:
        cpus=16,
        mem_mb=32000,
        time=7200
    conda:
        "../envs/superfocus.yaml"
    shell:
        """
        superfocus -b $HOME/superfocus_db/version2 -q {input} -dir {output.d} -a diamond -t {resources.cpus}
        """

rule run_kraken:
    input:
        r1 = os.path.join(PSEQDIR_TWO, "{sample}_good_out_R1.fastq"),
        r2 = os.path.join(PSEQDIR_TWO, "{sample}_good_out_R2.fastq")
    output:
        rt = os.path.join(OUTDIR, "{sample}", "kraken", "{sample}.report.tsv"),
        ot = os.path.join(OUTDIR, "{sample}", "kraken", "{sample}.output.tsv")
    resources:
        cpus=8,
        mem_mb=400000
    conda:
        "../envs/kraken.yaml"
    shell:
        """
        kraken2 --report {output.rt} \
                --output {output.ot} \
                --threads {resources.cpus} \
                {input.r1}
        """

rule run_singlem:
    input:
        r1 = os.path.join(PSEQDIR_TWO, "{sample}_good_out_R1.fastq"),
        r2 = os.path.join(PSEQDIR_TWO, "{sample}_good_out_R2.fastq")
    output:
        d = directory(os.path.join(OUTDIR, "{sample}", "singlem")),
        otu = os.path.join(OUTDIR, "{sample}", "singlem", "singlem_otu_table.tsv")
    conda:
        "../envs/singlem.yaml"
    resources:
        cpus=8,
        mem_mb=40000
    shell:
        """
        mkdir --parents {output.d};
        singlem pipe --forward {input.r1} --reverse {input.r2} --otu_table {output.otu} --output_extras --threads {resources.cpus}
        """

"""
In the rules below we use the m8 files from superfocus
to crate taxonomy tables.
"""

rule superfocus_taxonomy:
    input:
        m8 = os.path.join(OUTDIR, "{sample}", "superfocus", "{sample}.good_out_R1.fastq_alignments.m8"),
    output:
        os.path.join(OUTDIR, "{sample}", "superfocus", "{sample}_good_out.taxonomy")
    params:
        db = "/home/edwa0468/ncbi/taxonomy/taxonomy.sqlite3"
    resources:
        mem_mb=16000
    shell:
        """
        python3 /home/edwa0468/GitHubs/atavide/workflow/scripts/superfocus_to_taxonomy.py -f {input} --tophit -d {params.db} > {output}
        """

rule count_sf_taxonomy:
    input:
        os.path.join(OUTDIR, "{sample}", "superfocus", "{sample}_good_out.taxonomy")
    output:
        os.path.join(OUTDIR, "{sample}", "superfocus", "{sample}_tax_counts.tsv")
    params:
        s = "{sample}"
    resources:
        cpus=4,
        mem_mb=16000
    shell:
        """
        cut -d$'\t' -f 2- {input} | sed -e 's/\t/|/g' | \
        awk -v F={params.s} 'BEGIN {{print "Superkingdom|Phylum|Class|Order|Family|Genus|Species|Taxid\t"F}} s[$0]++ {{}} END {{ for (i in s) print i"\t"s[i] }}' \
        > {output}
        """

rule join_superfocus_taxonomy:
    input:
        expand(os.path.join(OUTDIR, "{smps}", "superfocus", "{smps}_tax_counts.tsv"), smps=SAMPLES)
    output:
        os.path.join(OUTDIR, "all_taxonomy.tsv")
    shell:
        """
        perl /home/edwa0468/GitHubs/atavide/workflow/scripts/joinlists.pl -h -z {input} > {output}
        """


