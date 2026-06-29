# QUICKSTART

## 1. Create environment

```bash
conda env create -f environment.yml
conda activate roarypanpca
```

## 2. Test with toy data

```bash
cp examples/toy_gene_presence_absence.Rtab data/roary/gene_presence_absence.Rtab
cp examples/toy_gene_presence_absence.csv  data/roary/gene_presence_absence.csv
cp examples/toy_metadata.tsv              data/metadata/metadata.tsv

bash scripts/run_pipeline.sh
```

## 3. Run with real Roary data

```bash
cp /path/to/gene_presence_absence.Rtab data/roary/gene_presence_absence.Rtab
cp /path/to/gene_presence_absence.csv  data/roary/gene_presence_absence.csv
bash scripts/run_pipeline.sh
```

## 4. Check outputs

```bash
cat results/pca/pca_explained_variance.tsv | head
head results/loadings/top_PC1_loadings_annotated.tsv
ls figures/
```

## 5. Open figures in WSL

```bash
explorer.exe figures
```
