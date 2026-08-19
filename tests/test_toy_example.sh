#!/usr/bin/env bash
set -euo pipefail

cp examples/toy_gene_presence_absence.Rtab data/roary/gene_presence_absence.Rtab
cp examples/toy_gene_presence_absence.csv data/roary/gene_presence_absence.csv
cp examples/toy_metadata.tsv data/metadata/metadata.tsv

bash scripts/run_pipeline.sh

test -s results/pca/pca_explained_variance.tsv
test -s results/loadings/top_PC1_loadings_annotated.tsv
test -s results/pcoa/jaccard_pcoa_scores_metadata.tsv
test -s results/pcoa/jaccard_pcoa_eigenvalues.tsv
test -s results/pcoa/jaccard_pcoa_diagnostics.tsv
test -s figures/PCA_labeled_genomes.png

grep -q "additive_correction_constant" results/pcoa/jaccard_pcoa_diagnostics.tsv
grep -q "raw_negative_eigenvalue_count" results/pcoa/jaccard_pcoa_diagnostics.tsv

echo "Toy workflow test passed."
