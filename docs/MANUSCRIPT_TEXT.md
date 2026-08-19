# Manuscript-ready method language

This page provides a starting point only. Edit it to match the exact dataset, software versions, metadata and parameters used in a real analysis.

## Methods

Pangenome ordination was performed from Roary gene presence/absence output using PanOrd. The `gene_presence_absence.Rtab` matrix was transposed so that genomes represented observations and gene clusters represented binary variables. Gene clusters with zero variance across the analyzed genomes were removed before ordination. Principal component analysis (PCA) was performed in R using `prcomp` with feature centering enabled and unit-variance scaling disabled (`center = TRUE`, `scale. = FALSE`). Genome scores were merged with available sample metadata for visualization. The proportion of variance explained by each principal component was calculated from the PCA singular values. Gene-cluster loadings were extracted for the major principal components and merged with annotations from `gene_presence_absence.csv` to identify candidate clusters associated with the observed gene-content axes.

As a complementary distance-based analysis, pairwise Jaccard dissimilarities were calculated from the binary genome-by-gene matrix using `vegan::vegdist(..., method = "jaccard", binary = TRUE)`. Because Jaccard dissimilarities can be non-Euclidean, principal coordinates analysis (PCoA) was performed with an additive correction using R `cmdscale(..., add = TRUE)`. PCoA eigenvalues, the additive correction constant and negative-eigenvalue diagnostics were retained with the analysis outputs.

## Results template

PCA summarized the dominant axes of gene-content variation among the analyzed genomes after zero-variance clusters were removed. PC1 explained **[X]%** and PC2 explained **[Y]%** of the centered matrix variance. The ordination showed **[describe clusters / gradient / overlap / outliers without assigning cause]**. Metadata overlay indicated that this structure **[did / did not]** correspond visually with **[metadata variable]**.

High-magnitude loadings on **[PC]** identified candidate gene clusters associated with the major separation axis. Several top-loading clusters **[did / did not]** share similar presence/absence patterns, suggesting **[a correlated accessory block / multiple independent patterns / further genomic-context analysis is needed]**. These features were treated as candidate contributors to the ordination rather than direct evidence of adaptation, phenotype or causation.

Jaccard PCoA showed **[broadly similar / partially different / substantially different]** genome-level structure relative to PCA. The additive correction constant was **[value]**, with **[N]** negative eigenvalues in the uncorrected distance representation. The comparison was used as a complementary description of gene-content structure rather than as an independent significance test.

## Interpretation note

If ordination groups align strongly with phylogenetic lineages, lineage history should be considered before ecological or functional explanations. Conversely, structure crossing lineage boundaries can motivate further investigation of mobile elements, horizontal transfer, ecological association or technical confounding, but PanOrd alone cannot discriminate among those mechanisms.
