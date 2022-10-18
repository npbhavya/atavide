#!/bin/bash

#SBATCH --job-name=bowtie2
#SBATCH --output=%x-%j.out.txt
#SBATCH --error=%x-%j.err.txt
#SBATCH --time=1-0
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=1
#SBATCH --mem=200G

bowtie2 --mm -p 16 -x host/GRCm38/GRCm38 -U ../mouse_output/filtlong/barcode11_filtlong.fastq | samtools view -@ 16 -bh | samtools sort -o ../mouse_output/host_mapped/barcode11.hostmapped.bam 
