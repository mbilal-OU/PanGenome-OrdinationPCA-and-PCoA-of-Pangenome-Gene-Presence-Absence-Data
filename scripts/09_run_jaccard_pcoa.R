#!/usr/bin/env Rscript
suppressPackageStartupMessages({ library(tidyverse); library(vegan) })
matrix_file <- "results/matrix/pca_matrix_genomes_by_genes.tsv"
metadata_file <- "data/metadata/metadata.tsv"
dir.create("results/pcoa", recursive = TRUE, showWarnings = FALSE); dir.create("figures", recursive = TRUE, showWarnings = FALSE)
X_df <- read_tsv(matrix_file, show_col_types = FALSE)
metadata <- if (file.exists(metadata_file)) read_tsv(metadata_file, show_col_types = FALSE) else X_df %>% select(genome)
X <- X_df %>% column_to_rownames("genome") %>% as.matrix(); storage.mode(X) <- "numeric"
dist_j <- vegdist(X, method = "jaccard", binary = TRUE)
pcoa <- cmdscale(dist_j, eig = TRUE, k = min(5, nrow(X) - 1))
scores <- as.data.frame(pcoa$points); colnames(scores) <- paste0("PCoA", seq_len(ncol(scores)))
scores <- scores %>% rownames_to_column("genome") %>% left_join(metadata, by = "genome")
write_tsv(scores, "results/pcoa/jaccard_pcoa_scores_metadata.tsv")
eig <- pcoa$eig; positive_eig <- eig[eig > 0]; variance <- positive_eig / sum(positive_eig)
var1 <- round(variance[1] * 100, 2); var2 <- round(variance[2] * 100, 2)
plot_by <- function(color_col) {
  if (!(color_col %in% colnames(scores))) return(NULL)
  p <- ggplot(scores, aes(x = PCoA1, y = PCoA2, color = .data[[color_col]])) + geom_point(size = 3, alpha = 0.85) + theme_bw(base_size = 12) + labs(title = paste0("Jaccard PCoA colored by ", color_col), x = paste0("PCoA1 (", var1, "%)"), y = paste0("PCoA2 (", var2, "%)"), color = color_col)
  ggsave(paste0("figures/Jaccard_PCoA_", color_col, ".pdf"), p, width = 7, height = 5)
  ggsave(paste0("figures/Jaccard_PCoA_", color_col, ".png"), p, width = 7, height = 5, dpi = 600)
}
for (col in c("species", "genus", "family", "source", "habitat", "geography", "host", "strain", "clade", "phenotype")) plot_by(col)
