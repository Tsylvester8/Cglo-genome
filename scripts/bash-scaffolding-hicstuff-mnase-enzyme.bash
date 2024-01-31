#!/bin/bash

##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=hicstuff-100bp-breaks 		#Job name
#SBATCH --time=07-00:00:00			#time to run the command in dd-hh:mm:ss format
#SBATCH --nodes=1				#number of nodes (computers)
#SBATCH --ntasks=1 				#number of commands to run
#SBATCH --cpus-per-task=25			#number of cpus each task can use
#SBATCH --mem=56G 				#memory per node
#SBATCH --output=hicstuff-100bp-breaks-out.log	#save stdout to file
#SBATCH --error=hicstuff-100bp-breaks-err.log	#save stderr to file

## OPTIONAL JOB SPECIFICATIONS
#SBATCH --mail-type=ALL                   #Send email on all job events
#SBATCH --mail-user=terrence@tamu.edu     #Send all emails to email_address 

# source anaconda profile
source /sw/eb/sw/Anaconda3/2021.05/etc/profile.d/conda.sh
# activate conda environment
conda activate /scratch/user/terrence/condaEnvs/hicstuff

hicstuff pipeline -g ../11.nuclear-only-assembly/post-polish-assembly/cglo-nuclear-genome.fasta ../../../../../RawData/Dovtail-seq/DTG-OmniC-164_R1_001.fastq.gz ../../../../../RawData/Dovtail-seq/DTG-OmniC-164_R2_001.fastq.gz -a bwa -e mnase -t 25 --filter --outdir ../6.hicstuff-pre-scaffolding/3.hicstuff-100bp-breaks
