# PanOrd quick start

## 1. Create the environment

```bash
conda env create -f environment.yml
conda activate panord
```

## 2. Learn with the simulated demo

Generate a deterministic synthetic pangenome with three planted accessory-gene groups and one designed outlier:

```bash
python scripts/00_generate_simulated_pangenome.py \
  --outdir examples/simulated_demo \
  --seed 42
```

Load it into the standard PanOrd input locations:

```bash
cp examples/simulated_demo/gene_presence_absence.Rtab data/roary/gene_presence_absence.Rtab
cp examples/simulated_demo/gene_presence_absence.csv  data/roary/gene_presence_absence.csv
cp examples/simulated_demo/metadata.tsv               data/metadata/metadata.tsv
```

Run:

```bash
bash scripts/run_pipeline.sh
```

The simulation is **teaching data only**. See [`docs/SIMULATED_DEMO.md`](docs/SIMULATED_DEMO.md) before interpreting the plots.

## 3. Or use the small repository toy files

```bash
cp examples/toy_gene_presence_absence.Rtab data/roary/gene_presence_absence.Rtab
cp examples/toy_gene_presence_absence.csv  data/roary/gene_presence_absence.csv
cp examples/toy_metadata.tsv               data/metadata/metadata.tsv
bash scripts/run_pipeline.sh
```

## 4. Run with real Roary data

```bash
cp /path/to/gene_presence_absence.Rtab data/roary/gene_presence_absence.Rtab
cp /path/to/gene_presence_absence.csv  data/roary/gene_presence_absence.csv
```

Optional metadata:

```bash
cp /path/to/metadata.tsv data/metadata/metadata.tsv
```

Then:

```bash
bash scripts/run_pipeline.sh
```

## 5. Inspect the outputs

```bash
head results/pca/pca_explained_variance.tsv
head results/loadings/top_PC1_loadings_annotated.tsv
head results/pcoa/jaccard_pcoa_diagnostics.tsv
ls figures/
```

Interpret the outputs in this order:

```text
ordination geometry
        ↓
metadata correspondence
        ↓
PCA loadings / gene patterns
        ↓
independent biological validation
```

## 6. WSL convenience

```bash
explorer.exe figures
```
