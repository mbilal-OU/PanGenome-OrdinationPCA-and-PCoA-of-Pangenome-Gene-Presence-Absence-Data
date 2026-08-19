# PanOrd FAQ

## Does ordination replace the Roary pangenome summary?

No. They answer different questions.

Roary-style core/accessory summaries are **gene-frequency summaries**. PanOrd asks how **whole genomes** are arranged based on their multi-gene presence/absence profiles.

## What does one point represent?

One point represents one genome. The coordinates are calculated from the genome's gene-content profile.

## Are PC1 and PC2 specific genes?

No. They are synthetic axes formed from combinations of many gene variables.

## What is a loading?

A loading is a gene-cluster coefficient for a PCA axis. Large absolute loadings identify candidate clusters strongly associated with movement along that axis.

## Does a large loading prove a gene caused the separation biologically?

No. High-loading genes are candidate contributors to the mathematical separation. Correlated genes, lineage structure, mobile DNA and technical artifacts can all generate strong loadings.

## Why remove zero-variance genes?

A gene that has the same 0/1 value in every genome cannot distinguish genomes. Strict core genes are therefore absent from presence/absence PCA even though they may be biologically essential.

## Why not standardize every binary gene before PCA?

PanOrd uses centered, unscaled PCA by default. Standardizing a very rare binary feature to unit variance can greatly amplify it. The unscaled choice lets the natural binary variance `p(1-p)` remain part of the geometry.

This is a methodological choice, not a universal rule. If you use another scaling strategy, report it explicitly.

## PCA or PCoA—which should I use?

They are complementary.

- **PCA** is feature-based and provides gene loadings.
- **Jaccard PCoA** is distance-based and ignores joint absences when computing similarity.

Use PCA when you want to connect structure back to candidate genes. Use Jaccard PCoA when you want a complementary binary-distance view. Comparing both is often more informative than choosing one by habit.

## Why can Jaccard PCoA have negative eigenvalues?

Jaccard dissimilarities are not guaranteed to be perfectly Euclidean. Classical PCoA can therefore produce negative eigenvalues.

PanOrd applies an additive correction before the final PCoA and writes diagnostics to:

```text
results/pcoa/jaccard_pcoa_diagnostics.tsv
results/pcoa/jaccard_pcoa_eigenvalues.tsv
```

## If PCA and PCoA disagree, which one is wrong?

Not necessarily either. They summarize the same binary data using different geometry. A disagreement can indicate that a pattern is sensitive to how gene-content differences are represented.

Inspect the matrix, rare features, loadings, distance structure, metadata and QC before deciding what the disagreement means.

## Does coloring by habitat test habitat association?

No. Coloring is visualization. A visual correspondence between habitat and ordination coordinates is exploratory and may be confounded by lineage or sampling design.

## Can PanOrd detect a new lineage or ecotype?

It can reveal a gene-content cluster worth investigating. It cannot by itself establish a new lineage, ecotype, adaptation or phenotype.

## Why include simulated data?

Real biological datasets do not come with a truth table. The simulated demo has planted group-specific gene blocks and a known outlier, so users can see how known structure appears in PCA, PCoA and loadings before interpreting unknown real data.
