#!/usr/bin/env bash
set -euo pipefail

RTAB="${1:-data/roary/gene_presence_absence.Rtab}"
CSV="${2:-data/roary/gene_presence_absence.csv}"
REPORT="results/qc/input_qc_report.txt"
mkdir -p results/qc

{
  echo "PanOrd input QC report"
  echo "======================"
  echo "Date: $(date)"
  echo
  echo "RTAB: $RTAB"
  echo "CSV : $CSV"
  echo
  [ -f "$RTAB" ] || { echo "ERROR: Missing $RTAB"; exit 1; }
  [ -f "$CSV" ] || { echo "ERROR: Missing $CSV"; exit 1; }
  echo "File sizes:"
  ls -lh "$RTAB" "$CSV"
  echo
  echo "Genome count from Rtab:"
  head -n 1 "$RTAB" | tr '\t' '\n' | tail -n +2 | wc -l
  echo "Gene cluster count from Rtab:"
  tail -n +2 "$RTAB" | wc -l
  echo
  echo "First 10 genome names:"
  head -n 1 "$RTAB" | tr '\t' '\n' | tail -n +2 | head -n 10
} | tee "$REPORT"

echo "Wrote QC report: $REPORT"
