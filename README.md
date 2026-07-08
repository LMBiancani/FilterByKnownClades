# FilterByKnownClades Scripts
Filters loci by comparing the likelihood of trees constrained to "Uncontested Clades" versus unconstrained trees.

## 0_update_variables.sh

Update variables and paths in `0_update_variables.sh`
This is a master parameter list that is sourced by all slurm scripts. 
Paths and parameters should be updated as needed. 
This script DOES NOT need to be run/executed separately, each slurm script will access it as needed.
IMPORTANT: User email address is not specified by variables file and needs to to updated individually in each slurm script!

## 1_prep_R_env.sh
```bash
sbatch 1_prep_R_env.sh
```
Creates a local space for R packages (`~/R-packages`), runs `install.packages.R`, and installs necessary R libraries.

## 2_generate_constraints.sh

```Bash
sbatch 2_generate_constraints.sh
```
Uses `generate_constraints.R` to create Newick constraint files for specific clades of interest.

## 3_iqtree_likelihoods.sh

```Bash
sbatch 3_iqtree_likelihoods.sh
```
Runs IQ-TREE on each locus under two conditions: unconstrained and constrained-to-known-clades.

## 4_LRT_filter.sh

```Bash
sbatch 4_LRT_filter.sh
```
Executes `LRT_filter.R` to perform Likelihood Ratio Tests, identifying loci where the constraint significantly worsens the fit (p < 0.05).

## 5_collect_filtered_loci.sh
```Bash
sbatch 5_collect_filtered_loci.sh
```
Uses collect_filtered_loci.R to sort loci into pass_0.05 and fail_0.05 directories based on LRT results.
