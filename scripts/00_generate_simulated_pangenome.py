#!/usr/bin/env python3
"""Generate a deterministic Roary-style teaching dataset for PanOrd.

The simulation is intentionally simple and transparent. It creates three genome
clusters with planted accessory-gene blocks, shared core genes, background
accessory variation, and one deliberately perturbed outlier. The dataset is for
method education only and must not be interpreted biologically.
"""

from __future__ import annotations

import argparse
import csv
import random
from pathlib import Path


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Generate a simulated pangenome ordination demo")
    p.add_argument("--outdir", default="examples/simulated_demo", help="Output directory")
    p.add_argument("--seed", type=int, default=42, help="Random seed (default: 42)")
    return p.parse_args()


def bernoulli(rng: random.Random, p: float) -> int:
    return 1 if rng.random() < p else 0


def main() -> None:
    args = parse_args()
    rng = random.Random(args.seed)
    outdir = Path(args.outdir)
    outdir.mkdir(parents=True, exist_ok=True)

    groups = ["A", "B", "C"]
    genomes = [f"{group}{i:02d}" for group in groups for i in range(1, 7)]
    genome_group = {g: g[0] for g in genomes}
    outlier = "C06"

    matrix: dict[str, list[int]] = {}
    truth_rows: list[dict[str, str]] = []

    # 30 strict core clusters: useful for illustrating why zero-variance genes
    # disappear before PCA.
    for i in range(1, 31):
        gene = f"SIM_CORE_{i:03d}"
        matrix[gene] = [1] * len(genomes)
        truth_rows.append({"Gene": gene, "truth_class": "strict_core", "designed_group": "all"})

    # Three planted accessory blocks. Genes are common in their designed group
    # and uncommon elsewhere, with stochastic noise so the groups are not perfect.
    for group in groups:
        for i in range(1, 16):
            gene = f"SIM_{group}_BLOCK_{i:03d}"
            values = []
            for genome in genomes:
                p = 0.90 if genome_group[genome] == group else 0.06
                values.append(bernoulli(rng, p))
            matrix[gene] = values
            truth_rows.append({"Gene": gene, "truth_class": "group_enriched", "designed_group": group})

    # Background accessory variation with heterogeneous prevalence.
    for i in range(1, 26):
        gene = f"SIM_BG_{i:03d}"
        prevalence = rng.uniform(0.15, 0.70)
        matrix[gene] = [bernoulli(rng, prevalence) for _ in genomes]
        truth_rows.append({"Gene": gene, "truth_class": "background_accessory", "designed_group": "none"})

    # Rare clusters provide a small cloud-like component.
    for i in range(1, 11):
        gene = f"SIM_RARE_{i:03d}"
        carriers = set(rng.sample(genomes, k=1 if i <= 6 else 2))
        matrix[gene] = [1 if genome in carriers else 0 for genome in genomes]
        truth_rows.append({"Gene": gene, "truth_class": "rare", "designed_group": "none"})

    # Deliberately perturb one C genome: weaken part of its own group block and
    # give it some A-block genes. This creates a known outlier for teaching.
    out_idx = genomes.index(outlier)
    c_genes = [g for g in matrix if g.startswith("SIM_C_BLOCK_")]
    a_genes = [g for g in matrix if g.startswith("SIM_A_BLOCK_")]
    for gene in c_genes[:8]:
        matrix[gene][out_idx] = 0
    for gene in a_genes[:6]:
        matrix[gene][out_idx] = 1

    # Ensure every non-core feature is variable. This avoids accidental constant
    # columns while preserving the conceptual design.
    for gene, values in matrix.items():
        if gene.startswith("SIM_CORE_"):
            continue
        if all(v == values[0] for v in values):
            values[rng.randrange(len(values))] = 1 - values[0]

    rtab_path = outdir / "gene_presence_absence.Rtab"
    with rtab_path.open("w", newline="") as fh:
        writer = csv.writer(fh, delimiter="\t", lineterminator="\n")
        writer.writerow(["Gene", *genomes])
        for gene, values in matrix.items():
            writer.writerow([gene, *values])

    csv_path = outdir / "gene_presence_absence.csv"
    csv_fields = [
        "Gene",
        "Non-unique Gene name",
        "Annotation",
        "No. isolates",
        "No. sequences",
        "Avg sequences per isolate",
        "Genome Fragment",
        "Min group size nuc",
        "Max group size nuc",
        "Avg group size nuc",
    ]
    truth_by_gene = {row["Gene"]: row for row in truth_rows}
    with csv_path.open("w", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=csv_fields)
        writer.writeheader()
        for gene, values in matrix.items():
            truth = truth_by_gene[gene]
            count = sum(values)
            label = truth["truth_class"]
            group = truth["designed_group"]
            annotation = (
                f"simulated {label} cluster"
                if group in {"all", "none"}
                else f"simulated accessory block enriched in group {group}"
            )
            writer.writerow(
                {
                    "Gene": gene,
                    "Non-unique Gene name": "",
                    "Annotation": annotation,
                    "No. isolates": count,
                    "No. sequences": count,
                    "Avg sequences per isolate": 1 if count else 0,
                    "Genome Fragment": "",
                    "Min group size nuc": 900,
                    "Max group size nuc": 1100,
                    "Avg group size nuc": 1000,
                }
            )

    metadata_path = outdir / "metadata.tsv"
    habitat = {"A": "soil", "B": "freshwater", "C": "host_associated"}
    with metadata_path.open("w", newline="") as fh:
        writer = csv.writer(fh, delimiter="\t", lineterminator="\n")
        writer.writerow(["genome", "clade", "source", "habitat", "simulation_status"])
        for genome in genomes:
            group = genome_group[genome]
            writer.writerow(
                [
                    genome,
                    f"SimGroup_{group}",
                    f"synthetic_source_{group}",
                    habitat[group],
                    "designed_outlier" if genome == outlier else "regular",
                ]
            )

    truth_path = outdir / "simulation_truth.tsv"
    with truth_path.open("w", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=["Gene", "truth_class", "designed_group"], delimiter="\t", lineterminator="\n")
        writer.writeheader()
        writer.writerows(truth_rows)

    readme_path = outdir / "README.md"
    readme_path.write_text(
        "# PanOrd simulated demo\n\n"
        "This directory was generated by `scripts/00_generate_simulated_pangenome.py`. "
        "It is **synthetic teaching data**, not a biological dataset.\n\n"
        f"Seed: `{args.seed}`  \n"
        f"Genomes: `{len(genomes)}`  \n"
        f"Gene clusters: `{len(matrix)}`  \n"
        f"Designed outlier: `{outlier}`\n\n"
        "See `docs/SIMULATED_DEMO.md` for the design and expected interpretation.\n"
    )

    print(f"Simulated PanOrd demo written to: {outdir}")
    print(f"Genomes: {len(genomes)}")
    print(f"Gene clusters: {len(matrix)}")
    print(f"Designed outlier: {outlier}")


if __name__ == "__main__":
    main()
