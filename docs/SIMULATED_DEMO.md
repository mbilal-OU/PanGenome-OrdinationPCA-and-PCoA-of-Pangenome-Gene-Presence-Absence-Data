# Simulated ordination demo

PanOrd includes a deterministic synthetic dataset generator so users can learn ordination on a matrix where the underlying structure is known in advance.

> **This is teaching data only.** No simulated point, gene cluster, habitat label, or group represents a real organism or biological result.

## Design

The default simulation contains 18 genomes divided into three groups:

```text
A01–A06   SimGroup_A
B01–B06   SimGroup_B
C01–C06   SimGroup_C
```

It contains five kinds of gene clusters:

| Designed class | Purpose |
|---|---|
| strict core | present in all genomes; demonstrates why zero-variance genes disappear before PCA |
| A-enriched accessory block | creates a known group-A gene-content signal |
| B-enriched accessory block | creates a known group-B signal |
| C-enriched accessory block | creates a known group-C signal |
| background / rare clusters | adds realistic-looking noise and cloud-like variation |

`C06` is deliberately perturbed: part of its C-enriched block is removed and several A-enriched genes are added. It should therefore behave as an outlier relative to the other C genomes.

## Generate the dataset

```bash
python scripts/00_generate_simulated_pangenome.py \
  --outdir examples/simulated_demo \
  --seed 42
```

Generated files:

```text
examples/simulated_demo/
├── gene_presence_absence.Rtab
├── gene_presence_absence.csv
├── metadata.tsv
├── simulation_truth.tsv
└── README.md
```

`simulation_truth.tsv` records which clusters were deliberately assigned to core, group-enriched, background, or rare classes.

## Run PanOrd on the simulation

```bash
cp examples/simulated_demo/gene_presence_absence.Rtab data/roary/gene_presence_absence.Rtab
cp examples/simulated_demo/gene_presence_absence.csv  data/roary/gene_presence_absence.csv
cp examples/simulated_demo/metadata.tsv               data/metadata/metadata.tsv
bash scripts/run_pipeline.sh
```

## What should you look for?

### PCA

The three groups should occupy distinguishable regions of the PCA landscape because each carries a partially distinct accessory-gene block. The exact orientation of the axes is arbitrary: a group appearing on the left in one run could appear on the right if an axis sign flips without changing the biological geometry.

`C06` should be displaced relative to the other C genomes because its gene-content profile was deliberately altered.

### Explained variance

A small number of PCs should capture a substantial fraction of the designed between-group signal, but noise and incomplete penetrance mean the structure is intentionally not perfect.

Do not expect a universal percentage threshold for a “good” PCA. Explained variance depends on the number of genomes, the number and prevalence of variable genes, and how concentrated the underlying structure is.

### PCA loadings

High-magnitude loadings on the PCs separating groups should be enriched for the planted `SIM_A_BLOCK_*`, `SIM_B_BLOCK_*`, or `SIM_C_BLOCK_*` clusters.

This is the key teaching point: because the true drivers are known in the simulation, users can see how a separation pattern maps back to gene-cluster features.

### Jaccard PCoA

Jaccard PCoA should recover a broadly similar group structure because group members share many presences within the designed accessory blocks. It need not be a rotated copy of the PCA plot because the two methods use different geometry.

PanOrd applies an additive correction before PCoA because Jaccard distances can be non-Euclidean. The correction and eigenvalue diagnostics are written to `results/pcoa/`.

## Why both methods?

PCA works directly on the centered gene-feature matrix and provides gene loadings. That makes it especially useful when the scientific goal is to identify candidate clusters associated with major directions of gene-content variation.

Jaccard PCoA works from pairwise binary dissimilarities. Joint absences do not count as evidence that two genomes are similar, which is often a useful property for accessory-gene data.

If PCA and Jaccard PCoA both show the same broad grouping, that is useful descriptive corroboration. It is **not** an independent statistical proof of biological groups.

## Exercises

1. Change the random seed and see which features remain stable.
2. Increase or decrease the group-block penetrance in the generator and observe how separation changes.
3. Remove the deliberate perturbation of `C06` and compare its position.
4. Compare top PC1 loadings against `simulation_truth.tsv`.
5. Color the same ordination by `clade`, `habitat`, and `simulation_status` and note that different metadata columns can describe the same geometry differently.
6. Add a technical metadata variable unrelated to the planted groups and verify that visual coloring alone does not create a biological association.

## Interpretation rule

For real data, the truth table does not exist. That is why PanOrd treats ordination as a **hypothesis-generating layer**: geometry first, metadata second, candidate features third, and independent biological validation last.
