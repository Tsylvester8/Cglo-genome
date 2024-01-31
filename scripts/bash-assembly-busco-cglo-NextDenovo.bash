#!/bin/bash

##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=cglo-NextDenovo-assembly 				#Job name
#SBATCH --time=2-00:00:00									#time to run the command in dd-hh:mm:ss format
#SBATCH --nodes=1											#number of nodes (computers)
#SBATCH --ntasks=1 											#number of commands to run
#SBATCH --cpus-per-task=25					 				#number of cpus each task can use
#SBATCH --mem=56G 											#memory per node
#SBATCH --output=cglo-ND-BUSCO-out.log							#save stdout to file
#SBATCH --error=cglo-ND-BUSCO-err.log								#save stderr to file

## OPTIONAL JOB SPECIFICATIONS
#SBATCH --mail-type=ALL                   #Send email on all job events
#SBATCH --mail-user=terrence@tamu.edu     #Send all emails to email_address 

module purge
module load BUSCO/4.1.2-foss-2019b-Python-3.7.4

busco -i ../1.Assembly/03.ctg_graph/nd.asm.fasta -c 25 -o cglo-ND-busco --out_path ../3.busco-pre-scaffolding -m geno -l endopterygota_odb10
