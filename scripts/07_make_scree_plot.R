#!/usr/bin/env Rscript
suppressPackageStartupMessages({ library(tidyverse) })
explained <- read_tsv("results/pca/pca_explained_variance.tsv", show_col_types = FALSE)
explained_top <- explained %>% slice_head(n = 10) %>% mutate(PC = factor(PC, levels = PC))
p <- ggplot(explained_top, aes(x = PC, y = explained_percent)) + geom_col() + theme_bw(base_size = 12) + labs(title = "PCA explained variance", x = "Principal component", y = "Explained variance (%)")
ggsave("figures/PCA_scree_plot.pdf", p, width = 7, height = 5)
ggsave("figures/PCA_scree_plot.png", p, width = 7, height = 5, dpi = 600)
