#!/usr/bin/env Rscript
suppressPackageStartupMessages({ library(tidyverse) })
args <- commandArgs(trailingOnly = TRUE)
scores_file <- ifelse(length(args) >= 1, args[1], "results/pca/pca_scores_metadata.tsv")
explained_file <- ifelse(length(args) >= 2, args[2], "results/pca/pca_explained_variance.tsv")
out_dir <- ifelse(length(args) >= 3, args[3], "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
scores <- read_tsv(scores_file, show_col_types = FALSE)
explained <- read_tsv(explained_file, show_col_types = FALSE)
pc1_var <- round(explained$explained_percent[1], 2); pc2_var <- round(explained$explained_percent[2], 2)
plot_by <- function(color_col) {
  if (!(color_col %in% colnames(scores))) return(NULL)
  p <- ggplot(scores, aes(x = PC1, y = PC2, color = .data[[color_col]])) + geom_point(size = 3, alpha = 0.85) + theme_bw(base_size = 12) + labs(title = paste0("Roary pangenome PCA colored by ", color_col), x = paste0("PC1 (", pc1_var, "%)"), y = paste0("PC2 (", pc2_var, "%)"), color = color_col)
  ggsave(file.path(out_dir, paste0("PCA_", color_col, ".pdf")), p, width = 7, height = 5)
  ggsave(file.path(out_dir, paste0("PCA_", color_col, ".png")), p, width = 7, height = 5, dpi = 600)
}
for (col in c("species", "genus", "family", "order", "class", "phylum", "source", "habitat", "geography", "host", "strain", "clade", "phenotype", "metadata_note")) plot_by(col)
