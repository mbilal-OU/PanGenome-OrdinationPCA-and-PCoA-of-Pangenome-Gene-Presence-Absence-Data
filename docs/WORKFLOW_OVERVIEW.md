# PanOrd workflow overview

PanOrd is intentionally organized as **two complementary ordination lenses** rather than a single linear analysis chain.

```text
                      Roary presence/absence
                               │
                               ▼
                     genome × gene matrix
                               │
                 remove zero-variance clusters
                               │
                  ┌────────────┴────────────┐
                  │                         │
                  ▼                         ▼
          centered unscaled PCA       Jaccard dissimilarity
                  │                         │
          ┌───────┼────────┐                ▼
          │       │        │          corrected PCoA
          ▼       ▼        ▼                │
       scores  variance  loadings           ▼
          │                │          distance geometry
          │                ▼                │
          │         annotated candidate     │
          │            gene clusters        │
          └──────────────┬──────────────────┘
                         ▼
              compare genome structure
                         │
                         ▼
                metadata correspondence
                         │
                         ▼
               biological hypotheses
```

## PCA branch

PCA works directly on the genome × gene matrix. PanOrd centers each binary feature but does not scale it to unit variance. Outputs include genome scores, explained variance and gene loadings.

The loadings branch is what makes PCA especially useful for interpretation: a genome-separation axis can be traced back to candidate gene clusters.

## Jaccard PCoA branch

Jaccard PCoA first converts the binary matrix into pairwise genome dissimilarities. Shared absences do not increase similarity.

Because Jaccard distances can be non-Euclidean, PanOrd applies an additive correction before classical PCoA and writes eigenvalue/correction diagnostics to `results/pcoa/`.

## Why compare them?

The methods are not duplicates. PCA asks for dominant directions of feature variance; Jaccard PCoA asks for a low-dimensional representation of pairwise binary dissimilarity.

Similar broad grouping across both views is useful descriptive corroboration. Different grouping is not automatically an error—it can reveal that the apparent structure depends on the geometry used to summarize the matrix.

## Simulated teaching route

Before using biological data, users can generate a known synthetic structure with:

```bash
python scripts/00_generate_simulated_pangenome.py --outdir examples/simulated_demo --seed 42
```

See [`SIMULATED_DEMO.md`](SIMULATED_DEMO.md).
