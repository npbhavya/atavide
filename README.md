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


# Installation and getting going

0. Make sure to have a conda environment with snakemake v.7.14 and higher installed \
    `conda create env -y workflow` \
    `conda activate workflow` \
    `conda install -c bioconda snakemake` \
  Setup [slurm profile](https://fame.flinders.edu.au/blog/2021/08/02/snakemake-profiles-updated)

1. Clone this repository from GitHub: \
    `git clone https://github.com/linsalrob/atavide.git` \
    `git checkout -b dev-np`
    
2. Install the python packages required to run atavide \
    `cd atavide & python setup.py install`
    
3. Test installation: \
  `atavide run --input test-data/SRR1237781_1.fastq.gz` \
  The log should complete with no errors, and output directory "atavide.out" should be generated with a copy of the input file

4. Install databases required,
    - Install the [appropriate super-focus database](https://cloudstor.aarnet.edu.au/plus/s/bjYDqqDXK5u7JiF) \
        Currently, superfocus database has to be downloaded manually to database directory
    - Copy the [NCBI taxonomy](https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/) (You really just need the [taxdump.tar.gz]           (https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/taxdump.tar.gz) file)
    Run the below command to install the databases \
        `atavide install database` \
    Note: If these databases are already installed, then add the directory file path to config.yaml.

5. To run atavide \
    `atavide run --input test-data --profile slurm`
  
  This will run all the steps in atavide mentioned below, or you have the option of running each module one at a time

### Steps:
*Module 1: Preprocessing only* 

- QC/QA with [prinseq++](https://github.com/Adrian-Cantu/PRINSEQ-plus-plus)
To run only this module run the command \
    `atavide run --input test-data --profile slurm -R QC`

*Module 2: Host contamination removal* 

- QC/QA with [prinseq++](https://github.com/Adrian-Cantu/PRINSEQ-plus-plus)
- Bowtie2/samtools to remove reads that mapped to host
Note: Have to provide the directory, bowtie2 indices names in the config file

        #examples to add host removal 
        host_dbpath: "host"
        host_dbname: "GCA_000001405.15_GRCh38_full_analysis_set.fna.bowtie_index"

*Module 3: Reads Annotation*

- QC/QA with [prinseq++](https://github.com/Adrian-Cantu/PRINSEQ-plus-plus)
- If host_dbpath and host_dbname set - will run through Host removal 
- Taxanomic annotation using [kraken2](https://github.com/DerrickWood/kraken2)
- Functional annotation using [SUPER_FOCUS](https://github.com/metageni/SUPER-FOCUS)
To run this module, the command is 
     
     `atavide run --input test-data --profile slurm -R ReadsAnnotation`
     
*Work in progress**

### Metagenome assembly
1. pairwise assembly of each sample using [megahit](https://github.com/voutcn/megahit)
2. extraction of all reads that do not assemble using samtools flags
3. assembly of all unassembled reads using [megahit](https://github.com/voutcn/megahit)
4. compilation of _all_ contigs into a single unified set using [Flye](https://github.com/fenderglass/Flye)
5. comparison of reads -> contigs to generate coverage

### MAG creation
1. [metabat](https://bitbucket.org/berkeleylab/metabat/src/master/)
2. [concoct](https://github.com/BinPro/CONCOCT)
3. Pairwise comparisons using [turbocor](https://github.com/dcjones/turbocor) followed by clustering

### Other Read-based annotations 
1. [singlem](https://github.com/wwood/singlem)
2. [FOCUS](https://github.com/metageni/FOCUS)

Want something else added to the suite? File an issue on GitHub and we'll add it ASAP!


