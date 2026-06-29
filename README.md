# PanGenome-Ordination

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![R](https://img.shields.io/badge/R-4.x-blue)
![Pangenomics](https://img.shields.io/badge/Topic-Pangenomics-green)
![Roary](https://img.shields.io/badge/Input-Roary-orange)

> A Roary-based workflow for interpretable PCA of pangenome gene presence/absence data.

**PanGenome-Ordination** converts Roary gene presence/absence output into publication-ready PCA plots, explained-variance tables, annotated loading tables, gene-pattern summaries, and optional Jaccard PCoA. The goal is not only to draw a PCA figure, but to teach users what PCA is doing in pangenomics and how to connect PCA separation back to candidate genes.

---

## Table of Contents

- [What This Does](#what-this-does)
- [Why PCA If Roary Already Gives Core and Accessory Genes?](#why-pca-if-roary-already-gives-core-and-accessory-genes)
- [Core Idea](#core-idea)
- [Input Files](#input-files)
- [Installation](#installation)
- [Quick Start With Example Data](#quick-start-with-example-data)
- [Run With Your Roary Output](#run-with-your-roary-output)
- [Output Files](#output-files)
- [How To Interpret Results](#how-to-interpret-results)
- [PCA vs Roary Summary](#pca-vs-roary-summary)
- [PCA vs PCoA](#pca-vs-pcoa)
- [Real Dataset Example: Deinococcus radiodurans](#real-dataset-example-deinococcus-radiodurans)
- [Troubleshooting](#troubleshooting)
- [Citation](#citation)

---

## What This Does

Roary produces a pangenome table that records whether each gene cluster is present or absent in each genome. PanGenome-Ordination uses that matrix to answer five practical questions:

1. Which genomes are similar or different based on gene content?
2. Is accessory genome variation structured or mostly random?
3. Are there outlier genomes?
4. Which principal components explain the strongest gene-content patterns?
5. Which gene clusters contribute most strongly to PCA separation?

The workflow produces:

```text
PCA plots
scree plot
PCA scores
explained variance table
PCA loadings
annotated top-loading genes
presence/absence pattern of top-loading genes
optional Jaccard PCoA
```

---

## Why PCA If Roary Already Gives Core and Accessory Genes?

Roary summary is **gene-centered**. It tells how frequent each gene cluster is:

```text
core       = present in almost all genomes
accessory  = present in some genomes
cloud      = present in few genomes
```

PCA is **genome-centered**. It asks:

```text
How are genomes arranged based on thousands of gene presence/absence features?
```

Roary can tell you:

```text
There are 2,000 accessory genes.
```

PCA can tell you:

```text
Those accessory genes form a strong 14-versus-2 genome pattern,
and PC1 explains 55% of the total gene-content variation.
```

**Roary summary describes pangenome composition. PCA describes the structure of gene-content variation among genomes.**

---

## Core Idea

Roary `.Rtab` orientation:

```text
rows    = gene clusters
columns = genomes
values  = 0/1
```

PCA orientation after transposition:

```text
rows    = genomes
columns = gene clusters
values  = 0/1
```

Workflow:

```text
gene_presence_absence.Rtab
        ↓
transpose matrix
        ↓
remove zero-variance genes
        ↓
PCA / Jaccard PCoA
        ↓
scores + plots
        ↓
extract top loadings
        ↓
merge with gene_presence_absence.csv annotations
        ↓
interpret candidate genes driving separation
```

---

## Input Files

Place Roary files here:

```text
data/roary/gene_presence_absence.Rtab
data/roary/gene_presence_absence.csv
```

| File | Purpose |
|---|---|
| `gene_presence_absence.Rtab` | Main binary PCA matrix |
| `gene_presence_absence.csv` | Annotation of top-loading gene clusters |
| `data/metadata/metadata.tsv` | Optional metadata for coloring and interpretation |

Minimum metadata format:

```text
genome    species    genus    source    habitat
Genome_A  Species_A  Genus_A  soil      terrestrial
Genome_B  Species_A  Genus_A  water     aquatic
```

The `genome` column must exactly match the `.Rtab` genome names.

---

## Installation

### Conda

```bash
conda env create -f environment.yml
conda activate roarypanpca
```

Verify:

```bash
Rscript -e "library(data.table); library(tidyverse); library(ggrepel); library(vegan); cat('R packages OK\n')"
python -c "import pandas as pd; print('Python OK')"
```

---

## Quick Start With Example Data

```bash
cp examples/toy_gene_presence_absence.Rtab data/roary/gene_presence_absence.Rtab
cp examples/toy_gene_presence_absence.csv  data/roary/gene_presence_absence.csv
cp examples/toy_metadata.tsv              data/metadata/metadata.tsv

bash scripts/run_pipeline.sh
```

---

## Run With Your Roary Output

```bash
cp /path/to/gene_presence_absence.Rtab data/roary/gene_presence_absence.Rtab
cp /path/to/gene_presence_absence.csv  data/roary/gene_presence_absence.csv
```

If you do not have metadata yet, create taxonomy-only metadata:

```bash
python scripts/01_make_taxonomy_metadata.py \
  --rtab data/roary/gene_presence_absence.Rtab \
  --species "Deinococcus radiodurans" \
  --genus "Deinococcus" \
  --family "Deinococcaceae" \
  --order "Deinococcales" \
  --class_name "Deinococci" \
  --phylum "Deinococcota" \
  --out data/metadata/metadata.tsv
```

Then run:

```bash
bash scripts/run_pipeline.sh
```

---

## Output Files

| Output | Meaning |
|---|---|
| `results/qc/input_qc_report.txt` | Input file checks |
| `results/matrix/pca_matrix_genomes_by_genes.tsv` | Transposed PCA matrix |
| `results/matrix/gene_frequency_summary.tsv` | Gene frequency and core/accessory class |
| `results/pca/pca_scores_metadata.tsv` | Genome PCA coordinates plus metadata |
| `results/pca/pca_explained_variance.tsv` | Explained variance per PC |
| `results/loadings/pca_loadings.tsv` | Gene loading values |
| `results/loadings/pca_loadings_annotated.tsv` | Loadings merged with Roary annotations |
| `results/loadings/top_PC1_loadings_annotated.tsv` | Top candidate genes for PC1 separation |
| `results/loadings/top20_PC1_presence_absence_with_header.tsv` | Presence/absence pattern of top PC1 genes |
| `results/pcoa/jaccard_pcoa_scores_metadata.tsv` | Jaccard-distance PCoA scores |
| `figures/PCA_labeled_genomes.png` | PCA plot with genome labels |
| `figures/PCA_scree_plot.png` | Scree plot |
| `figures/PCA_<metadata>.png` | PCA colored by metadata |
| `figures/Jaccard_PCoA_<metadata>.png` | Jaccard PCoA colored by metadata |

---

## How To Interpret Results

### PCA scores

Scores are genome coordinates. Genomes far apart have different gene-content profiles.

### Explained variance

If PC1 explains a high percentage, one major gene-content pattern dominates the dataset.

### PCA loadings

Loadings identify gene clusters contributing most strongly to each PC.

Use careful wording:

```text
High-loading genes are candidate drivers of PCA separation.
```

Do not overclaim:

```text
PCA alone does not prove adaptation, virulence, selection, or phenotype.
```

---

## PCA vs Roary Summary

| Analysis | Main question | Output |
|---|---|---|
| Roary summary | How many genes are core/accessory/cloud? | Gene category counts |
| PCA | How are genomes structured by gene-content variation? | Genome ordination and gene loadings |

---

## PCA vs PCoA

| Method | Input | Strength |
|---|---|---|
| PCA | Gene presence/absence matrix | Gives gene loadings |
| Jaccard PCoA | Genome-genome distance matrix | Well-suited for binary dissimilarity |

Recommended strategy:

```text
Use PCA to identify candidate gene drivers.
Use Jaccard PCoA as a distance-based validation.
```

---

## Real Dataset Example: Deinococcus radiodurans

In a demonstration run using 16 *Deinococcus radiodurans* genomes:

```text
Original Roary gene clusters: 4,272
Variable gene clusters used for PCA: 2,048
PC1 explained variance: 55.30%
PC2 explained variance: 9.11%
PC3 explained variance: 7.52%
PC1 + PC2 + PC3: 71.92%
```

Top PC1-loading genes included phage/mobile-element-associated and accessory genes, including `tnpB`, phage terminase, transporters, kinases, radical SAM proteins, and hypothetical proteins. Several top PC1 genes were present in 14 genomes and absent in two genomes, suggesting that PC1 captured a major accessory gene-content block.

This should be interpreted as an exploratory candidate pattern, not proof of adaptation.

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---|---|---|
| `there is no package called data.table` | R packages not installed | `conda env create -f environment.yml` |
| PCA plot has one color | Metadata column is constant | Add source/habitat/clade metadata |
| Genome names do not merge | Metadata names do not match `.Rtab` | Check `.Rtab` header |
| Weird genome name like `1F_...` | Windows line endings | `sed -i 's/\r$//' file` |
| PC1 dominated by one genome | Outlier or assembly artifact | Check QC, contamination, gene count |
| Top genes are all hypothetical | Annotation incomplete | Add eggNOG/functional annotation |

---

## Citation

If you use this workflow, please cite:

```text
Bilal M. PanGenome-Ordination: A Roary-Based Workflow for Interpretable PCA of Pangenome Gene Presence/Absence Data. GitHub. 2026.
```

Also cite Roary and any packages used in your analysis.
