#!/usr/bin/env Rscript
suppressPackageStartupMessages({ library(data.table); library(tidyverse) })
args <- commandArgs(trailingOnly = TRUE)
rtab_file <- ifelse(length(args) >= 1, args[1], "data/roary/gene_presence_absence.Rtab")
out_matrix <- ifelse(length(args) >= 2, args[2], "results/matrix/pca_matrix_genomes_by_genes.tsv")
out_freq <- ifelse(length(args) >= 3, args[3], "results/matrix/gene_frequency_summary.tsv")
dir.create(dirname(out_matrix), recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(out_freq), recursive = TRUE, showWarnings = FALSE)
rtab <- fread(rtab_file, data.table = FALSE, check.names = FALSE)
gene_ids <- rtab[[1]]
mat_gene_by_genome <- as.matrix(rtab[, -1])
rownames(mat_gene_by_genome) <- gene_ids
storage.mode(mat_gene_by_genome) <- "numeric"
n_genomes <- ncol(mat_gene_by_genome)
freq_tbl <- tibble(
  Gene = gene_ids,
  presence_count = rowSums(mat_gene_by_genome),
  frequency = presence_count / n_genomes,
  roary_like_class = case_when(
    frequency >= 0.99 ~ "core",
    frequency >= 0.95 ~ "soft_core",
    frequency >= 0.15 ~ "shell_accessory",
    TRUE ~ "cloud_rare"
  )
)
write_tsv(freq_tbl, out_freq)
X <- t(mat_gene_by_genome)
gene_var <- apply(X, 2, var)
X_var <- X[, gene_var > 0, drop = FALSE]
message("Genomes: ", nrow(X_var))
message("Original gene clusters: ", ncol(X))
message("Variable gene clusters used for PCA: ", ncol(X_var))
message("Zero-variance gene clusters removed: ", sum(gene_var == 0))
X_out <- as.data.frame(X_var) %>% rownames_to_column("genome")
write_tsv(X_out, out_matrix)
