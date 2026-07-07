args = commandArgs(trailingOnly=TRUE)
argsLen <- length(args);
if (argsLen == 0){
  cat("Syntax: Rscript collect_gtrees.R [path to iqtree array work folder] \n")
  cat("Example: Rscript collect_gtrees.R /data/schwartzlab/Biancani/FilterByKnownClades/output/Fong/iqtree_assessment \n")
  quit()
}

library(stringr)
library(tidyverse)

#array_work_folder <- "/data/schwartzlab/Biancani/FilterByKnownClades/output/Liu/iqtree_assessment"
array_work_folder <- args[1] #path to iqtree array work folder
setwd(array_work_folder)

# Path to the Constrained (may be slightly shorter) gene tree list
file_path <- "GeneTreesConstrained/gtrees.txt"
loci_list <- readLines(file_path) #list of loci/gtree names

extract_likelihood <- function(iqtree_output){
  iqtree_lines <- readLines(iqtree_output)
  # Loop through each line in the file
  for (line in iqtree_lines) {
    # Look for the line containing "Log-likelihood of the tree:"
    if (grepl("Log-likelihood of the tree:", line)) {
      # Extract maximum likelihood and standard error
      max_likelihood <- as.numeric(str_extract(line, "-*[0-9][0-9.]*"))
      standard_error <- as.numeric(str_remove(str_extract(line, "[0-9][0-9.]*\\)"),"\\)"))
      break  # Exit loop once found
    }
  }
  return(c(max_likelihood,standard_error))
}

LnL_unconstr <- c() #initiate list of likelihood scores for unconstrained gene trees
SE_unconstr <- c() # initiate list of standard error values for unconstrained gene trees
LnL_constr <- c() #initiate list of likelihood scores for constrained gene trees
SE_constr <- c() #initiate list of standard error values for unconstrained gene trees
MaxLnL <- c()

# Extract constrained and unconstrained likelihood and standard error from .iqtree output files for each simulated locus
for (locus in loci_list){
  #Unconstrained
  iqtree_output <- paste("GeneTreesUnconstrained/inference_", locus,".iqtree", sep = "")
  unconstrained <- extract_likelihood(iqtree_output)
  LnL_unconstr <- c(LnL_unconstr,unconstrained[1])
  SE_unconstr <- c(SE_unconstr,unconstrained[2])
  #Constrained
  iqtree_output <- paste("GeneTreesConstrained/inference_", locus,".iqtree", sep = "")
  constrained <- extract_likelihood(iqtree_output)
  LnL_constr <- c(LnL_constr,constrained[1])
  SE_constr <- c(SE_constr,constrained[2])
  #Comparison
  if (unconstrained[1] > constrained[1]){
    MaxLnL <- c(MaxLnL, "Unconstrained")
  } else {
    MaxLnL <- c(MaxLnL,"Constrained")
  }
}

df <- tibble(Locus = loci_list, MaxLnL, LnL_unconstr, SE_unconstr, LnL_constr, SE_constr)

# Calculate z-score and p-value from LnLs and SEs and store these values in new columns
df <- df %>%
  mutate(
    z_score = (LnL_unconstr - LnL_constr) / sqrt(SE_unconstr^2 + SE_constr^2),
    p_value = 2 * (1 - pnorm(abs(z_score)))
  )

write.csv(df, "Loci_LnL_all.csv")

# Extract rows where p-value is less than 0.05 (ie. likelihoods are significantly different)
# and MaxLnL is "Unconstrained" - these are the loci that should be removed!
removed_loci_df <- df %>%
  filter(p_value < 0.05 & MaxLnL == "Unconstrained")

write.csv(removed_loci_df, "Loci_LnL_removed.csv")

# Filter df for rows not present in removed_loci_df based on locus_id
filtered_loci_df <- df %>%
  anti_join(removed_loci_df, by = "Locus")

write.csv(filtered_loci_df, "Loci_LnL_filtered.csv")

# Export list of "good" filtered loci:

writeLines(filtered_loci_df$Locus, con = "Loci_filtered.txt")
writeLines(removed_loci_df$Locus, con = "Loci_removed.txt")

