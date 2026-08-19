# PanOrd interpretation guide

Use this guide after the workflow finishes. The central rule is simple:

> **Describe the geometry before explaining the biology.**

---

## 1. Confirm the matrix you actually analysed

Start with:

```text
results/qc/input_qc_report.txt
results/matrix/gene_frequency_summary.tsv
results/matrix/pca_matrix_genomes_by_genes.tsv
```

Check:

- how many genomes entered the analysis;
- how many gene clusters were present originally;
- how many zero-variance clusters were removed;
- whether the remaining feature count is plausible;
- whether sample names match the intended metadata.

A striking ordination built from the wrong genome set is still the wrong analysis.

---

## 2. Read PCA variance before reading colors

Open:

```text
results/pca/pca_explained_variance.tsv
figures/PCA_scree_plot.png
```

Ask:

- How much does PC1 explain?
- How much do PC1 + PC2 explain together?
- Is there one dominant axis or a gradual decay across PCs?

Do not treat an arbitrary explained-variance percentage as a universal quality threshold. Pangenomes with diffuse accessory variation can require many dimensions.

---

## 3. Describe the unlabeled geometry

Inspect:

```text
figures/PCA_labeled_genomes.png
```

Before looking at metadata, describe only what the coordinates show:

- compact clusters;
- overlapping clouds;
- continuous gradients;
- isolated outliers;
- one genome driving an axis;
- multiple subgroups.

This prevents metadata labels from dictating the story before the structure itself has been assessed.

---

## 4. Overlay metadata as an exploratory layer

Use metadata-colored PCA and PCoA plots to ask whether the ordination aligns with variables such as:

- clade or lineage;
- host;
- geography;
- source;
- habitat;
- phenotype;
- sequencing or study batch.

A colored plot is not a formal association test. Apparent separation may reflect population structure, uneven sampling, batch effects, genome quality, or other confounders.

---

## 5. Compare PCA with Jaccard PCoA

Inspect:

```text
results/pcoa/jaccard_pcoa_scores_metadata.tsv
results/pcoa/jaccard_pcoa_eigenvalues.tsv
results/pcoa/jaccard_pcoa_diagnostics.tsv
figures/Jaccard_PCoA_*.png
```

Ask whether the broad structure is similar under the two geometries.

Agreement is useful descriptive corroboration. Disagreement is also informative: PCA and Jaccard PCoA weight the binary matrix differently, so a structure that appears only under one method deserves closer inspection.

Check the PCoA diagnostics rather than assuming the Jaccard distance matrix was perfectly Euclidean.

---

## 6. Trace a PCA axis back to gene clusters

For PC1, inspect:

```text
results/loadings/top_PC1_loadings_annotated.tsv
results/loadings/top20_PC1_presence_absence_with_header.tsv
```

Repeat for PC2 or PC3 when those axes matter.

Ask:

- Are the same genes repeatedly present in one ordination group and absent in another?
- Are the top features mobile-element, phage, plasmid, defense, transporter, metabolic, AMR, or hypothetical genes?
- Do many top genes have nearly identical presence/absence patterns?

If many genes share the same pattern, treat them as a possible **correlated accessory block** until genomic context shows otherwise.

---

## 7. Investigate outliers before celebrating them

An isolated genome can be biologically interesting, but it can also reflect:

- contamination;
- low completeness;
- annotation failure;
- unusually fragmented assembly;
- duplicate or mislabeled input;
- inflated gene count;
- plasmid/mobile-element burden;
- taxonomic misassignment.

Check genome QC and annotation summaries before interpreting an outlier as a novel biological state.

---

## 8. Compare with phylogeny or lineage structure

If ordination clusters match phylogenetic clades, accessory gene content may largely reflect lineage history.

If ordination cuts across phylogeny, possible explanations include horizontal transfer, convergent acquisition, ecological association, recombination-linked structure, or technical effects. Those possibilities require additional analyses; the ordination alone cannot choose among them.

---

## 9. Use careful language

### Appropriate

```text
PC1 separated two sets of genomes based on gene-content variation.
High-magnitude PC1 loadings identified candidate accessory clusters associated with this separation.
Jaccard PCoA recovered a broadly similar genome-level pattern.
```

### Requires more evidence

```text
These genes caused adaptation.
The PCA cluster represents a new ecotype.
These genes explain virulence.
The outlier evolved independently because of horizontal transfer.
```

---

## 10. Finish with an explicit hypothesis

A useful PanOrd result ends with a testable statement, for example:

> A set of co-occurring accessory clusters is associated with the major gene-content axis separating lineage A from lineage B; genomic-context and phylogeny-aware analyses are needed to determine whether the pattern reflects linked mobile DNA, lineage history, or an ecological association.

That is stronger scientifically than treating the scatter plot itself as the conclusion.
