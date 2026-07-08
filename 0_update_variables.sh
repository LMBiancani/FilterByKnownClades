################################################
# 0_update_variables.sh
# This is a list of variables used by all FilterByKnownClades scripts.
# UPDATE THESE VARIABLES BEFORE RUNNING ANY OF THE SCRIPTS.
# variables are grouped by their first point of use but remain available for all subsequent scripts.

set -a  # Automatically export all variables defined after this line

## 0_update_variables.sh

#***# Full path to FilterByKnownClades directory containing scripts (update this path after moving/copying these scripts!)
SCRIPTS="/project/pi_rsschwartz_uri_edu/Biancani/FilterByKnownClades"

#***# Path to output directory for FilterByKnownClades (specify a directory name and full path for output of filtering)
Output="/project/pi_rsschwartz_uri_edu/Biancani/FilterByKnownClades_Output"

## 1_prep_R_env.sh

# List of necessary R packages (separated by spaces)
R_packages="ape stringr"
### "igraph phangorn MASS clusterGeneration ggplot2 phytools geiger MultiRNG EnvStats extraDistr tidyverse castor Quartet"

#***# Local directory to install R packages - change to your home directory!
R_package_DIR="/home/biancani_uri_edu"

## 2_generate_constraints.sh

# Path to generate_constraints.sh
GenCon="$SCRIPTS/2_generate_constraints.sh"
# Path to generate_constraints.R
GenConR="$SCRIPTS/generate_constraints.R"
# Path to script-specific output directory:
out2="$Output/2_constraint_trees"

#***# Full path to input clades file (groups.csv):
clades=/scratch4/workspace/biancani_uri_edu-LociSimulation/mammal_loci/groups.csv
# Input clades: a taxon-to-group correspondence CSV table with the following format:
# Group,Taxa
# group1,taxonName1
# group1,taxonName2
# group2,taxonName3
# group2,taxonName4

#***# Input: path to directory containing aligned loci you wish to filter:
Alignments="/scratch4/workspace/biancani_uri_edu-LociSimulation/mammal_loci"

## 3_iqtree_likelihoods.sh

# Path to IQTREE executable:
IQTREE="/project/pi_rsschwartz_uri_edu/Biancani/Software/iqtree-2.1.2-Linux/bin/iqtree2"
# Path to iqtree_likelihoods.sh
IQTL="$SCRIPTS/iqtree_likelihoods.sh"
# Path to script-specific output directory:
out3="$Output/3_likelihoods"

## 4_LRT_filter.sh

# Path to script-specific output directory:
out4="$Output/4_lrt_results"
# Path to LRT_filter.R:
LRTfilter="$SCRIPTS/LRT_filter.R"

## 5_collect_filtered_loci.sh

# Path to collect_filtered_loci.R
CFL="$SCRIPTS/collect_filtered_loci.R"
# p threshold:
Pvalue=0.05
# Path to script-specific output directory:
out5="$Output/5_loci_filtered_by_known_clades"

set +a  # Stop automatically exporting
################################################
