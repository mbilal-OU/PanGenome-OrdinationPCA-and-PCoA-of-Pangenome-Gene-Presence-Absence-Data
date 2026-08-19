# Changelog

## 0.2.0 - 2026-08-19

### Identity and documentation
- Reframed the project as **PanOrd - Pangenome Ordination Workbench**.
- Rebuilt the README around ordination concepts, method choice, interpretation and scientific guardrails.
- Added a distinct ordination-map figure with explicitly simulated genome points.
- Expanded PCA/PCoA concepts, interpretation guidance, FAQ, workflow overview and manuscript-ready method language.

### Simulated teaching data
- Added `scripts/00_generate_simulated_pangenome.py`.
- The deterministic demo creates three planted accessory-gene groups, background variation, strict core genes, rare clusters and one designed outlier.
- Added `docs/SIMULATED_DEMO.md` and CI coverage for the simulator.

### PCoA
- Added explicit Jaccard distance-matrix output.
- Added an additive correction for non-Euclidean Jaccard dissimilarities before classical PCoA.
- Added PCoA eigenvalue and correction diagnostics.

### Project consistency
- Renamed the Conda environment to `panord`.
- Updated citation metadata to version 0.2.0.
- Extended the toy workflow test to validate the PCoA diagnostics.
