#!/usr/bin/env Rscript
suppressPackageStartupMessages({ library(tidyverse); library(ggrepel) })
scores <- read_tsv("results/pca/pca_scores_metadata.tsv", show_col_types = FALSE)
explained <- read_tsv("results/pca/pca_explained_variance.tsv", show_col_types = FALSE)
pc1_var <- round(explained$explained_percent[1], 2); pc2_var <- round(explained$explained_percent[2], 2)
p <- ggplot(scores, aes(x = PC1, y = PC2)) + geom_point(size = 3, alpha = 0.85) + geom_text_repel(aes(label = genome), size = 3, max.overlaps = 100) + theme_bw(base_size = 12) + labs(title = "Roary pangenome PCA", subtitle = "Genome labels show sample-level gene-content separation", x = paste0("PC1 (", pc1_var, "%)"), y = paste0("PC2 (", pc2_var, "%)"))
ggsave("figures/PCA_labeled_genomes.pdf", p, width = 8, height = 6)
ggsave("figures/PCA_labeled_genomes.png", p, width = 8, height = 6, dpi = 600)
