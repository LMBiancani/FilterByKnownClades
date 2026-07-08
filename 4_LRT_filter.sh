#!/bin/bash
#SBATCH --job-name=LRT_filter
#SBATCH --partition=uri-cpu
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --constraint=avx512
#SBATCH --mail-user="biancani@uri.edu" #UPDATE
#SBATCH --mail-type=ALL

# Source master parameters script:
vars="0_update_variables.shiables.sh"
source $vars
echo "Variables sourced into current shell environment:"
cat $vars

# --- Environment Setup (Unity) ---
module purge
module load uri/main
module load foss/2024a
module load R/4.3.2-gfbf-2023a

export GLIBCXX_PATH="/modules/uri_apps/software/GCCcore/13.3.0/lib64"
export LD_LIBRARY_PATH=$GLIBCXX_PATH:$LD_LIBRARY_PATH
export R_LIBS=~/R-packages

# --- Execute ---
echo "Running Likelihood Ratio Test";
# input (3_iqtree_likelihoods.sh)
IQ_DIR="$out3"
OutDir="$out4"
mkdir -p "$OutDir"
OUT_FILE="$OutDir/lrt_results.csv"
Rscript $LRTfilter "$IQ_DIR" "$OUT_FILE"
