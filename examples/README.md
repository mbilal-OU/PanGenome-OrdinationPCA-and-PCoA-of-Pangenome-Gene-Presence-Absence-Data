# PanOrd example data

This repository provides two different teaching examples.

## Small toy files committed to the repository

```text
toy_gene_presence_absence.Rtab
toy_gene_presence_absence.csv
toy_metadata.tsv
```

These are tiny Roary-like fixtures used by CI and for a fast first run. Genome_7 and Genome_8 lack an accessory block present in Genome_1–Genome_6.

## Rich simulated ordination demo

Generate it on demand:

```bash
python scripts/00_generate_simulated_pangenome.py \
  --outdir examples/simulated_demo \
  --seed 42
```

This creates 18 synthetic genomes, three planted accessory-gene groups, background variation, strict core genes, rare clusters, and one deliberately perturbed outlier.

The simulated dataset is designed for learning **what PCA, loadings and Jaccard PCoA are doing** when the ground truth is known. It is not biological data.

See [`../docs/SIMULATED_DEMO.md`](../docs/SIMULATED_DEMO.md).
