# PCA and PCoA concepts for pangenome data

PanOrd starts from a binary gene presence/absence matrix and asks a genome-centered question:

> How are genomes arranged when each genome is described by hundreds or thousands of gene-cluster presences and absences?

This page explains what PCA and PCoA are doing, why both are useful, and what their outputs do **not** prove.

---

## The input geometry

A Roary `.Rtab` file is usually arranged as:

```text
rows    = gene clusters
columns = genomes
values  = 0/1 presence/absence
```

For ordination, PanOrd transposes it to:

```text
rows    = genomes
columns = gene clusters
values  = 0/1 presence/absence
```

Each genome can therefore be imagined as one point in a space with one dimension per gene cluster. If 2,000 variable clusters remain, the genome occupies a point in a 2,000-dimensional feature space.

Ordination replaces that high-dimensional description with a few synthetic axes that preserve the strongest structure according to a defined geometry.

---

## Why zero-variance genes are removed

A gene present in every genome contributes the same value to every row. A gene absent from every genome does the same. Neither can distinguish genomes in the current dataset.

Strict core clusters therefore have zero variance in a 0/1 matrix and contribute nothing to PCA separation. Removing them is not saying that core genes are biologically unimportant; it simply reflects that they do not vary in this particular presence/absence analysis.

---

# PCA

## What PCA does

Principal component analysis finds orthogonal directions through feature space that capture decreasing amounts of variance.

- **PC1** captures the largest possible variance direction.
- **PC2** captures the largest remaining direction constrained to be orthogonal to PC1.
- later PCs capture progressively smaller residual patterns.

The axes are linear combinations of the original gene variables.

## What a PCA point means

A point is one genome. Its coordinates are called **scores**.

Two nearby genomes have similar coordinates on the displayed PCs. That usually indicates similar combinations of gene-presence features along those major variation axes, but the 2D plot does not contain all information in the original matrix.

## What explained variance means

If PC1 explains 40% of the variance, then the first PCA axis represents 40% of the total variance in the centered matrix.

There is no universal threshold at which a PCA becomes “good.” A complex pangenome may distribute variation across many dimensions, while a strong accessory block can produce one dominant PC.

Always report the percentages on the displayed axes.

## What PCA loadings mean

Each gene cluster receives a coefficient on each PC. These coefficients are called **loadings**.

Large absolute loadings indicate gene clusters strongly associated with movement along that axis.

The sign is directional and can flip if the whole PC axis is multiplied by -1; that does not change the underlying geometry. For initial candidate screening, magnitude is often more important than sign.

High-loading genes can be correlated with one another. Twenty top-loading genes may therefore represent one linked prophage, plasmid, genomic island, or other co-occurring block rather than twenty independent biological effects.

---

## Why PanOrd uses centered, unscaled PCA

PanOrd currently runs:

```r
prcomp(X, center = TRUE, scale. = FALSE)
```

For a binary variable with prevalence *p*, variance is:

```text
p(1-p)
```

That means genes near intermediate prevalence naturally have more variance than genes found in only one genome or in almost every genome.

PanOrd does **not** silently standardize every binary cluster to unit variance because doing so can give very rare genes disproportionately large influence. This is a methodological choice, not a universal rule. If you choose a different scaling strategy, report it explicitly because the ordination can change.

---

# Jaccard PCoA

## Why a distance-based method?

Principal coordinates analysis (PCoA) starts from a pairwise distance or dissimilarity matrix instead of directly from the original feature matrix.

PanOrd uses **Jaccard dissimilarity** for binary presence/absence data.

For two genomes, define:

- `a`: genes present in both;
- `b`: genes present only in genome 1;
- `c`: genes present only in genome 2.

Jaccard similarity is:

```text
a / (a + b + c)
```

and Jaccard dissimilarity is:

```text
1 - similarity
```

Genes absent from both genomes are not counted as evidence of similarity.

That property can be useful in pangenomics because a shared absence may simply mean neither genome carries a particular accessory feature.

## What a PCoA point means

Again, each point is one genome. PCoA constructs coordinates intended to represent the pairwise dissimilarity structure in a lower-dimensional Euclidean space.

The axes are **not gene variables** and PCoA does not provide the same direct gene-loading interpretation as PCA.

## Why PanOrd applies an additive correction

Jaccard distances can be non-Euclidean, which can generate negative eigenvalues in classical PCoA. Ignoring that issue can make axis-percentage interpretation misleading.

PanOrd therefore uses an additive correction in `cmdscale(..., add = TRUE)` and writes the correction/eigenvalue diagnostics to `results/pcoa/`.

This does not make PCoA “better” than PCA. It makes the distance geometry explicit and auditable.

---

# PCA vs Jaccard PCoA

| Question | PCA | Jaccard PCoA |
|---|---|---|
| Input | genome × gene matrix | genome × genome distance matrix |
| Geometry | variance in centered feature space | pairwise Jaccard dissimilarity |
| Shared absence contributes? | indirectly through feature values | no |
| Gene loadings available? | yes | no direct equivalent |
| Best use in PanOrd | discover structure and candidate gene drivers | complementary distance-based structure check |
| Main caution | gene prevalence affects variance; correlated genes share loadings | non-Euclidean distances require diagnostics/correction |

A useful workflow is:

```text
PCA → describe structure → inspect loadings
  │
  └── compare broad geometry with Jaccard PCoA
```

The two plots do not need to look identical. A rotated, stretched, or partially different pattern can arise because they encode the data using different geometry.

---

# Metadata does not create the ordination

Metadata colors are overlaid **after** the coordinates are calculated. Coloring a PCA by habitat or clade does not cause the separation.

If groups appear separated after coloring, that is an exploratory observation that the ordination structure aligns with that metadata variable. It is not automatically a significance test and does not establish causality.

Potential confounding factors include lineage, geography, sampling design, genome quality, annotation quality, sequencing source, and mobile-element burden.

---

# Core, accessory and rare genes

### Strict core genes

Strict core genes have no presence/absence variance and are removed from PCA. They can still be biologically central and important for phylogeny or function.

### Accessory genes

Accessory genes often provide the variation that drives pangenome ordination. Mobile elements, defense systems, transporters, metabolic loci, AMR genes, virulence-associated loci, or many uncharacterized genes can contribute.

### Rare genes

Rare genes have low prevalence and low variance in unscaled binary PCA. A rare gene can still be biologically important, but it will not necessarily dominate the PCA simply because it is unusual.

---

# Safe interpretation language

Appropriate:

```text
PC1 separated two groups of genomes based on gene-content variation.
High-magnitude PC1 loadings identified candidate gene clusters associated with that separation.
Jaccard PCoA recovered a broadly similar genome-level structure.
```

Too strong without additional evidence:

```text
PCA proves these genes caused adaptation.
The separated cluster is a new ecological lineage.
The top-loading genes are responsible for virulence.
```

Ordination is best used as a **hypothesis generator** that connects complex gene-content matrices to interpretable patterns worth validating with other analyses.
