# PCA Concepts for Roary Pangenomes

## What problem does PCA solve?

Roary produces a high-dimensional gene presence/absence matrix. Each genome may be described by thousands of gene clusters. PCA reduces this matrix into a small number of axes that summarize the strongest gene-content patterns.

## What Roary summary tells you

Roary summary tells how many genes are core, soft-core, shell, and cloud. This is gene-frequency information.

## What PCA tells you

PCA tells how genomes are arranged based on gene-content variation.

It answers:

```text
Which genomes are similar?
Which genomes are different?
Are there outliers?
Are there subgroups?
Which genes drive the separation?
```

## Core genes

Core genes are present in all or nearly all genomes. They usually include housekeeping genes, ribosomal proteins, DNA replication genes, transcription/translation genes, and basic metabolism. Core genes usually do not separate genomes in PCA because they have little or no variance.

## Accessory genes

Accessory genes are present in some genomes and absent in others. They can include plasmid genes, prophage genes, transposases, restriction-modification systems, transporters, virulence genes, AMR genes, stress-response genes, and habitat-specific metabolic genes. Accessory genes usually drive pangenome PCA.

## Ribosomal genes

Ribosomal genes are usually conserved core genes. They are important for phylogeny and taxonomic placement, but usually not for gene presence/absence PCA.

## PCA scores

Scores are genome coordinates on PC axes.

## PCA loadings

Loadings are gene-cluster contributions to PC axes. High-loading genes are candidate genes driving separation.

## Careful wording

Correct:

```text
High-loading genes are candidate drivers of gene-content separation.
```

Incorrect:

```text
PCA proves these genes cause adaptation.
```
