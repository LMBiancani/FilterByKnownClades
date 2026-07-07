#!/bin/bash
#SBATCH --job-name="FilterLoci"
#SBATCH --time=2:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -c 1
#SBATCH --mem-per-cpu=1G
#SBATCH --mail-user="biancani@uri.edu" #CHANGE THIS to your user email address
#SBATCH --mail-type=ALL

module load R/4.0.3-foss-2020b

## UPDATE as needed...
# path to Project Directory:
PROJECT=/data/schwartzlab/Biancani/FilterByKnownClades
# path to IQtree scripts:
scripts_dir=$PROJECT/01_iqtree
# path to data directory:
DATA=$PROJECT/data
# Dataset name:
DATASET="McGowen"
# path to output folder:
OUTPUT=$PROJECT/output/$DATASET
# name of iqtree array work folder (will be created if doesn't exist):
array_work_folder=$OUTPUT/iqtree_assessment

# generate a list of locus names and collect gene trees:
for type in "Constrained" "Unconstrained"
do
  GTT=$type
  GTREES=$array_work_folder/GeneTrees$GTT # path to gene Trees
  cd $GTREES
  date
  ( > gtrees.txt; ls *.treefile | awk -F'inference_|.treefile' '{print $2}' >> gtrees.txt)
  ( > gtrees.tre; ls *.treefile | while read line1; do cat ${line1} >> gtrees.tre; done )
  date
done

cd $array_work_folder
echo $array_work_folder

# run R script to extract gene tree likelihood scores and standard error (also compare constrained vs. unconstrained likelihoods via z-score and create list of filtered loci).
Rscript ${scripts_dir}/collect_gtrees.R $array_work_folder

cd $array_work_folder

FILTERED=$DATA/$DATASET/simulated_loci_filtered
mkdir -p $FILTERED

cat "Loci_filtered.txt" | while read line
do
  cp $DATA/$DATASET/simulated_loci/$line $FILTERED
done
date

