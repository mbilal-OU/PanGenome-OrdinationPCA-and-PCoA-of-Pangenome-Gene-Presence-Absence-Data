#!/usr/bin/env bash
set -euo pipefail

RTAB="data/roary/gene_presence_absence.Rtab"
CSV="data/roary/gene_presence_absence.csv"
METADATA="data/metadata/metadata.tsv"
MATRIX="results/matrix/pca_matrix_genomes_by_genes.tsv"
GENE_FREQ="results/matrix/gene_frequency_summary.tsv"
SCORES="results/pca/pca_scores_metadata.tsv"
EXPLAINED="results/pca/pca_explained_variance.tsv"
LOADINGS="results/loadings/pca_loadings.tsv"

mkdir -p logs data/metadata results/matrix results/pca results/pcoa results/loadings results/qc figures

bash scripts/00_check_inputs.sh "$RTAB" "$CSV"

if [ ! -f "$METADATA" ]; then
  echo "No metadata found at $METADATA; creating genome-only metadata."
  head -n 1 "$RTAB" | tr '\t' '\n' | tail -n +2 | awk 'BEGIN{print "genome"} {print $1}' > "$METADATA"
fi

Rscript scripts/02_prepare_matrix.R "$RTAB" "$MATRIX" "$GENE_FREQ"
Rscript scripts/03_run_pca.R "$MATRIX" "$METADATA" "$SCORES" "$EXPLAINED" "$LOADINGS"
Rscript scripts/04_extract_loadings.R "$LOADINGS" "$CSV" "results/loadings/pca_loadings_annotated.tsv"
Rscript scripts/05_make_plots.R "$SCORES" "$EXPLAINED" "figures"
Rscript scripts/06_make_labeled_pca_plot.R
Rscript scripts/07_make_scree_plot.R
bash scripts/08_extract_top_loading_gene_patterns.sh 20 PC1
bash scripts/08_extract_top_loading_gene_patterns.sh 20 PC2
bash scripts/08_extract_top_loading_gene_patterns.sh 20 PC3
Rscript scripts/09_run_jaccard_pcoa.R

echo
echo "PanOrd complete."
echo "  Figures           : figures/"
echo "  PCA scores        : results/pca/"
echo "  Annotated loadings: results/loadings/"
echo "  Jaccard PCoA      : results/pcoa/"
echo "  PCoA diagnostics  : results/pcoa/jaccard_pcoa_diagnostics.tsv"
