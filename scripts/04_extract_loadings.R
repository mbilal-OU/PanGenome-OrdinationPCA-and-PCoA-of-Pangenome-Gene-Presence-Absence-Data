#!/usr/bin/env Rscript
suppressPackageStartupMessages({ library(data.table); library(tidyverse) })
args <- commandArgs(trailingOnly = TRUE)
loadings_file <- ifelse(length(args) >= 1, args[1], "results/loadings/pca_loadings.tsv")
csv_file <- ifelse(length(args) >= 2, args[2], "data/roary/gene_presence_absence.csv")
out_file <- ifelse(length(args) >= 3, args[3], "results/loadings/pca_loadings_annotated.tsv")
loadings <- read_tsv(loadings_file, show_col_types = FALSE)
roary_csv <- fread(csv_file, data.table = FALSE, check.names = FALSE)
annotation_cols <- c("Gene", "Non-unique Gene name", "Annotation", "No. isolates", "No. sequences", "Avg sequences per isolate", "Genome Fragment", "Min group size nuc", "Max group size nuc", "Avg group size nuc")
roary_annot <- roary_csv %>% select(any_of(annotation_cols))
loadings_annotated <- loadings %>% left_join(roary_annot, by = "Gene")
write_tsv(loadings_annotated, out_file)
for (pc in c("PC1", "PC2", "PC3")) {
  if (pc %in% colnames(loadings_annotated)) {
    top_tbl <- loadings_annotated %>% mutate(abs_loading = abs(.data[[pc]])) %>% arrange(desc(abs_loading)) %>% slice_head(n = 100)
    write_tsv(top_tbl, paste0("results/loadings/top_", pc, "_loadings_annotated.tsv"))
  }
}
