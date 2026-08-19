# Contributing to PanOrd

PanOrd is intended to stay focused on **interpretable ordination of pangenome gene presence/absence matrices**.

Useful contributions include:

- fixes to Roary input handling;
- improved PCA/PCoA diagnostics;
- clearer statistical explanations;
- reproducible teaching examples;
- plotting improvements that preserve scientific interpretability;
- tests for edge cases;
- support for additional presence/absence formats when their semantics are explicit.

## Before opening a pull request

Run the project tests:

```bash
conda env create -f environment.yml
conda activate panord
bash tests/test_simulator.sh
bash tests/test_toy_example.sh
```

## Scientific changes

Changes to ordination geometry, scaling, distance metrics, feature filtering, PCoA correction, or loading interpretation should document:

1. what mathematical behavior changes;
2. why the change is appropriate for binary pangenome data;
3. whether existing output values or interpretation change;
4. how the behavior is tested.

Do not convert exploratory ordination patterns into causal biological claims in documentation or example text.

## Simulated data

Synthetic examples must be labeled clearly as simulated and should record their design or random seed so users can distinguish known planted structure from biological observations.

## Scope

PanOrd is downstream of pangenome reconstruction. Genome download/QC, pangenome construction, phylogeny, GWAS, AMR and other analyses can be linked as complementary workflows but should not be folded into PanOrd unless they are directly necessary for ordination interpretation.
