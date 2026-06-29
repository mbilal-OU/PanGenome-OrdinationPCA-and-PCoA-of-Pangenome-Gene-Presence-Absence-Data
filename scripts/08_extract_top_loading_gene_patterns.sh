#!/usr/bin/env bash
set -euo pipefail
TOP_N="${1:-20}"
PC="${2:-PC1}"
LOADINGS="results/loadings/top_${PC}_loadings_annotated.tsv"
RTAB="data/roary/gene_presence_absence.Rtab"
OUT_DIR="results/loadings"
GENE_LIST="${OUT_DIR}/top${TOP_N}_${PC}_genes.txt"
OUT_NO_HEADER="${OUT_DIR}/top${TOP_N}_${PC}_presence_absence.tsv"
OUT_WITH_HEADER="${OUT_DIR}/top${TOP_N}_${PC}_presence_absence_with_header.tsv"
[ -f "$LOADINGS" ] || { echo "ERROR: Missing $LOADINGS"; exit 1; }
cut -f1 "$LOADINGS" | tail -n +2 | head -n "$TOP_N" > "$GENE_LIST"
awk -F'\t' 'NR==FNR{genes[$1]=1; next} FNR==1{next} $1 in genes{print}' "$GENE_LIST" "$RTAB" > "$OUT_NO_HEADER"
head -n 1 "$RTAB" > "${OUT_DIR}/header.tmp"
cat "${OUT_DIR}/header.tmp" "$OUT_NO_HEADER" > "$OUT_WITH_HEADER"
rm "${OUT_DIR}/header.tmp"
echo "Wrote: $OUT_WITH_HEADER"
