#!/usr/bin/env Rscript
suppressPackageStartupMessages({ library(tidyverse); library(vegan) })

matrix_file <- "results/matrix/pca_matrix_genomes_by_genes.tsv"
metadata_file <- "data/metadata/metadata.tsv"
dir.create("results/pcoa", recursive = TRUE, showWarnings = FALSE)
dir.create("figures", recursive = TRUE, showWarnings = FALSE)

X_df <- read_tsv(matrix_file, show_col_types = FALSE)
metadata <- if (file.exists(metadata_file)) read_tsv(metadata_file, show_col_types = FALSE) else X_df %>% select(genome)
X <- X_df %>% column_to_rownames("genome") %>% as.matrix()
storage.mode(X) <- "numeric"

if (nrow(X) < 3) stop("Jaccard PCoA requires at least three genomes.")

# Binary Jaccard dissimilarity. Joint absences do not contribute to similarity.
dist_j <- vegdist(X, method = "jaccard", binary = TRUE)

distance_matrix <- as.data.frame(as.matrix(dist_j)) %>% rownames_to_column("genome")
write_tsv(distance_matrix, "results/pcoa/jaccard_distance_matrix.tsv")

k <- min(5, nrow(X) - 1)

# Record the raw classical PCoA eigenvalue behavior first. Jaccard distances can
# be non-Euclidean, so negative eigenvalues are possible.
raw_pcoa <- suppressWarnings(cmdscale(dist_j, eig = TRUE, k = k, add = FALSE))
raw_eig <- raw_pcoa$eig

# Apply the additive correction implemented by cmdscale (Cailliez correction)
# so the ordination is performed on an Euclideanized distance matrix.
pcoa <- cmdscale(dist_j, eig = TRUE, k = k, add = TRUE)

scores <- as.data.frame(pcoa$points)
colnames(scores) <- paste0("PCoA", seq_len(ncol(scores)))
scores <- scores %>% rownames_to_column("genome") %>% left_join(metadata, by = "genome")
write_tsv(scores, "results/pcoa/jaccard_pcoa_scores_metadata.tsv")

corrected_eig <- pcoa$eig
positive_total <- sum(corrected_eig[corrected_eig > 0])
eigen_tbl <- tibble(
  axis = paste0("Axis", seq_along(corrected_eig)),
  eigenvalue = corrected_eig,
  positive_eigenvalue = corrected_eig > 0,
  explained_percent = if_else(
    corrected_eig > 0 & positive_total > 0,
    corrected_eig / positive_total * 100,
    0
  ),
  cumulative_positive_percent = cumsum(if_else(
    corrected_eig > 0 & positive_total > 0,
    corrected_eig / positive_total * 100,
    0
  ))
)
write_tsv(eigen_tbl, "results/pcoa/jaccard_pcoa_eigenvalues.tsv")

additive_constant <- if (!is.null(pcoa$ac)) pcoa$ac else 0
raw_negative <- sum(raw_eig < -sqrt(.Machine$double.eps))
corrected_negative <- sum(corrected_eig < -sqrt(.Machine$double.eps))

diagnostics <- tibble(
  metric = c(
    "n_genomes",
    "n_variable_gene_clusters",
    "additive_correction_constant",
    "raw_negative_eigenvalue_count",
    "raw_min_eigenvalue",
    "corrected_negative_eigenvalue_count",
    "corrected_min_eigenvalue"
  ),
  value = c(
    nrow(X),
    ncol(X),
    additive_constant,
    raw_negative,
    min(raw_eig),
    corrected_negative,
    min(corrected_eig)
  )
)
write_tsv(diagnostics, "results/pcoa/jaccard_pcoa_diagnostics.tsv")

positive_eig <- corrected_eig[corrected_eig > 0]
variance <- positive_eig / sum(positive_eig)
var1 <- if (length(variance) >= 1) round(variance[1] * 100, 2) else NA_real_
var2 <- if (length(variance) >= 2) round(variance[2] * 100, 2) else NA_real_

plot_by <- function(color_col) {
  if (!(color_col %in% colnames(scores))) return(NULL)
  p <- ggplot(scores, aes(x = PCoA1, y = PCoA2, color = .data[[color_col]])) +
    geom_point(size = 3, alpha = 0.85) +
    theme_bw(base_size = 12) +
    labs(
      title = paste0("Jaccard PCoA colored by ", color_col),
      subtitle = "Classical PCoA with additive correction for non-Euclidean distances",
      x = paste0("PCoA1 (", var1, "%)"),
      y = paste0("PCoA2 (", var2, "%)"),
      color = color_col
    )
  ggsave(paste0("figures/Jaccard_PCoA_", color_col, ".pdf"), p, width = 7, height = 5)
  ggsave(paste0("figures/Jaccard_PCoA_", color_col, ".png"), p, width = 7, height = 5, dpi = 600)
}

for (col in c("species", "genus", "family", "source", "habitat", "geography", "host", "strain", "clade", "phenotype", "simulation_status")) plot_by(col)

message("Jaccard PCoA complete.")
message("Additive correction constant: ", additive_constant)
message("Raw negative eigenvalues: ", raw_negative)
message("Corrected negative eigenvalues: ", corrected_negative)
