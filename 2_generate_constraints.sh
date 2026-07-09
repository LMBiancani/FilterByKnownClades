#!/bin/bash
#SBATCH --job-name=constraints
#SBATCH --partition=uri-cpu
#SBATCH --time=00:15:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --constraint=avx512
#SBATCH --mail-user="biancani@uri.edu" #UPDATE
#SBATCH --mail-type=ALL

# Source master parameters script:
vars="0_update_variables.sh"
source $vars
echo "Variables sourced into current shell environment:"
cat $vars

# Output subdirectory for the constraint tree:
mkdir -p "$out2"

# --- Environment Setup ---
module purge
module load uri/main
module load foss/2024a
module load R/4.3.2-gfbf-2023a

export GLIBCXX_PATH="/modules/uri_apps/software/GCCcore/13.3.0/lib64"
export LD_LIBRARY_PATH=$GLIBCXX_PATH:$LD_LIBRARY_PATH
export R_LIBS=$R_package_DIR/R-packages

# --- Execute ---
Rscript $GenConR "$Alignments" "$out2" "$clades"

# --- Audit & Confirmation ---
echo "------------------------------------------------"
echo "Post-Processing Audit:"
expected_count=$(ls -1 "$Alignments"/*.fas | wc -l)
actual_count=$(ls -1 "$out2"/*_constraint.newick 2>/dev/null | wc -l)

echo "Expected constraints: $expected_count"
echo "Generated constraints: $actual_count"

if [ "$expected_count" -eq "$actual_count" ]; then
    echo "SUCCESS: All constraint files were generated correctly."
else
    echo "WARNING: Count mismatch! Some loci may not have enough taxa to form a constraint."
fi
echo "------------------------------------------------"
