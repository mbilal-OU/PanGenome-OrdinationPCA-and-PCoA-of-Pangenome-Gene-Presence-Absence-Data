#!/usr/bin/env bash
set -euo pipefail
cp examples/toy_gene_presence_absence.Rtab data/roary/gene_presence_absence.Rtab
cp examples/toy_gene_presence_absence.csv data/roary/gene_presence_absence.csv
cp examples/toy_metadata.tsv data/metadata/metadata.tsv
bash scripts/run_pipeline.sh
test -f results/pca/pca_explained_variance.tsv
test -f results/loadings/top_PC1_loadings_annotated.tsv
test -f figures/PCA_labeled_genomes.png
echo "Toy test passed."
