#!/usr/bin/env bash
set -euo pipefail

OUTDIR="$(mktemp -d)/panord_sim"
python scripts/00_generate_simulated_pangenome.py --outdir "$OUTDIR" --seed 42

test -s "$OUTDIR/gene_presence_absence.Rtab"
test -s "$OUTDIR/gene_presence_absence.csv"
test -s "$OUTDIR/metadata.tsv"
test -s "$OUTDIR/simulation_truth.tsv"

python - "$OUTDIR" <<'PY'
import csv
import sys
from pathlib import Path

outdir = Path(sys.argv[1])
with (outdir / "gene_presence_absence.Rtab").open() as fh:
    rows = list(csv.reader(fh, delimiter="\t"))

header = rows[0]
assert header[0] == "Gene"
assert len(header) == 19, f"expected 18 genomes, got {len(header)-1}"
assert len(rows) == 111, f"expected 110 clusters + header, got {len(rows)} rows"

with (outdir / "metadata.tsv").open() as fh:
    meta = list(csv.DictReader(fh, delimiter="\t"))
assert len(meta) == 18
assert sum(row["simulation_status"] == "designed_outlier" for row in meta) == 1
assert next(row["genome"] for row in meta if row["simulation_status"] == "designed_outlier") == "C06"

with (outdir / "simulation_truth.tsv").open() as fh:
    truth = list(csv.DictReader(fh, delimiter="\t"))
assert sum(row["truth_class"] == "strict_core" for row in truth) == 30
assert sum(row["truth_class"] == "group_enriched" for row in truth) == 45
PY

echo "Simulated generator test passed."
