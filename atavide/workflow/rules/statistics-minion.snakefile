"""
The rules that generate statistics output after QC
"""
rule post_qc_stats:
    """
    Count the statistics after complete QC
    """
    input:
        fqdir = QCDIR_TWO
    output:
        stats = os.path.join(STATS, "post_qc_statistics.tsv")
    script:
        "../scripts/countfastq.py"