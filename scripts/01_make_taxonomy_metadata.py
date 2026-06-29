#!/usr/bin/env python3
import argparse
import pandas as pd

def read_genomes_from_rtab(rtab_file):
    with open(rtab_file, 'r', encoding='utf-8', errors='replace') as handle:
        header = handle.readline().rstrip('\n\r').split('\t')
    if len(header) < 2:
        raise ValueError('Rtab header does not contain genome columns.')
    return header[1:]

def main():
    parser = argparse.ArgumentParser(description='Create taxonomy-only metadata using exact genome names from Roary Rtab.')
    parser.add_argument('--rtab', required=True)
    parser.add_argument('--species', required=True)
    parser.add_argument('--genus', required=True)
    parser.add_argument('--family', required=True)
    parser.add_argument('--order', required=True)
    parser.add_argument('--class_name', required=True)
    parser.add_argument('--phylum', required=True)
    parser.add_argument('--out', required=True)
    args = parser.parse_args()
    genomes = read_genomes_from_rtab(args.rtab)
    metadata = pd.DataFrame({
        'genome': genomes,
        'species': args.species,
        'genus': args.genus,
        'family': args.family,
        'order': args.order,
        'class': args.class_name,
        'phylum': args.phylum,
        'metadata_note': 'taxonomy_only_metadata_generated_from_Rtab_genome_names'
    })
    metadata.to_csv(args.out, sep='\t', index=False)
    print(f'Wrote metadata for {len(metadata)} genomes: {args.out}')
if __name__ == '__main__': main()
