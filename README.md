[![Edwards Lab](https://img.shields.io/badge/Bioinformatics-EdwardsLab-03A9F4)](https://edwards.flinders.edu.au)
[![DOI](https://www.zenodo.org/badge/403921714.svg)](https://www.zenodo.org/badge/latestdoi/403921714)
[![DOI](https://img.shields.io/badge/DOI-WorkflowHub-yellowgreen)](https://doi.org/10.48546/WORKFLOWHUB.WORKFLOW.241.1)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![GitHub language count](https://img.shields.io/github/languages/count/linsalrob/atavide)


# atavide

`atavide` is a simple, yet complete workflow for metagenomics data analysis, including QC/QA, optional host removal, assembly and cross-assembly, and individual read based annotations. We have also built in some advanced analytics including tools to assign annotations from reads to contigs, and to generate metagenome-assembled genomes in several different ways, giving you the power to explore your data!

`atavide` is 100% snakemake and conda, so you only need to install the snakemake workflow, and then everything else will be installed with conda.


It is definitely a work in progress, but you can run it with the following command 

```bash
atavide run --input test-data
```

But you will need a [slurm profile](https://fame.flinders.edu.au/blog/2021/08/02/snakemake-profiles-updated) to make this work!


## Installation 

0. Make sure to have a conda environment with snakemake v.7.14 and higher installed \
        
            conda create env -y workflow
            conda activate workflow
            conda install -c conda-forge mamba
            conda install -c bioconda snakemake
 
 Setup [slurm profile](https://fame.flinders.edu.au/blog/2021/08/02/snakemake-profiles-updated)

1. Clone this repository from GitHub:

            git clone https://github.com/linsalrob/atavide.git
            #this will be removed once this branch is tested
            git checkout -b dev
    
2. Install the python packages required to run atavide

        cd atavide & python setup.py install
   

3. Install databases required,
    - Install the [appropriate super-focus database](https://cloudstor.aarnet.edu.au/plus/s/bjYDqqDXK5u7JiF) 
    - Copy the [NCBI taxonomy](https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/) (You really just need the [taxdump.tar.gz]   (https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz) file)
    - [Kraken2 database](https://genome-idx.s3.amazonaws.com/kraken/k2_standard_16gb_20220926.tar.gz) standard 16GB database
    - Host database, [GRCh38] (https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.bowtie_index.tar.gz) downloaded by default
  
    Run the below command to install the databases
    
        atavide install database
        
    Note: If these databases are already installed, then add the directory file path to config.yaml.


4. Test installation: 

        atavide reads --input test-data --preprocess paired
    
  The log should complete with no errors, and output directory "atavide.out" should be generated with a copy of the input file
  

## Running Atavide
    
  To run atavide

    atavide reads --input test-data --preprocess paired --profile slurm
  
  This will run all the steps in atavide mentioned below, or you have the option of running each module one at a time
  
  To run long reads through atavide
  
        atavide reads --input test-data --preprocess paired --profile slurm

  ### Steps:
  *Preprocessing only* 
  
  - QC/QA with [prinseq++](https://github.com/Adrian-Cantu/PRINSEQ-plus-plus)
  - Bowtie2/samtools to remove reads that mapped to host
    Note: Have to provide the directory, bowtie2 indices names in the config file

            #examples to add host removal 
            customHostDirectory: "host"
            host_dbname: "GCA_000001405.15_GRCh38_full_analysis_set.fna.bowtie_index"

  - Taxanomic annotation using [kraken2](https://github.com/DerrickWood/kraken2)
  - Functional annotation using [SUPER_FOCUS](https://github.com/metageni/SUPER-FOCUS)
   
## Output 
The results are saved in atavide.out/statistics directory. 
This directory should be filled with the followig files, 

- initial_read_statistics.tsv: The initial read sequence file statitics
  The column names are Filename, Number of sequences, total bp, shortest sequence length, longest sequence length, N50, N75 and AuN 
- av_quality_scores_by_position.tsv: The quality score of reads by bp position post QC and host removal 
- kraken_species_rarefaction.tsv: Number of species identified from subset of metagenome samples to plot rarefaction curves 
  The columns include, fraction of the subset, number of species within each metagenome 
- Kraken taxa output:
  - kraken_families.tsv
  - kraken_genera.tsv
  - kraken_phyla.tsv
  - kraken_species.tsv
- Superfocus funcational profiles across the metagenomes, outputs saved to superfocus_functions.tsv.gz
  
### More to add 
Want something else added to the suite? File an issue on GitHub and we'll add it ASAP!




