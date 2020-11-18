#!/usr/bin/env python

import argparse
import csv
import json
import sys


def parse_bracken_output(path_to_bracken_output):
    """
    Args:
        path_to_mlst_result (str): Path to the bracken output file.
    Returns:
        list of dict: Parsed bracken output.
        For example:
        [
            {
                'name': 'Homo sapiens',
                'taxonomy_id': '9606',
                'taxonomy_lvl': 'S',
                'kraken_assigned_reads': 100,
                'added_reads': 5,
                'new_est_reads': 105,
                'fraction_total_reads': 0.0052
            },
            ...
        ]
    """
    bracken_output = []

    int_fields = [
        'kraken_assigned_reads',
        'added_reads',
        'new_est_reads',
    ]

    float_fields = [
        'fraction_total_reads'
    ]

    with open(path_to_bracken_output) as bracken_output_file:
        reader = csv.DictReader(bracken_output_file, delimiter='\t')
        for row in reader:
            for field in int_fields:
                row[field] = int(row[field])
            for field in float_fields:
                row[field] = float(row[field])
            bracken_output.append(row)

    return bracken_output

def calculate_total_reads(parsed_bracken_output):
    total_reads = 0
    for record in parsed_bracken_output:
        total_reads += record['new_est_reads']

    return total_reads


def get_estimated_reads_by_name(parsed_bracken_output, name):
    reads = 0
    for record in parsed_bracken_output:
        if record['name'] == name:
            reads = record['new_est_reads']

    return reads


def main(args):
    bracken_output = parse_bracken_output(args.bracken_output)

    total_reads = calculate_total_reads(bracken_output)
    host_reads = get_estimated_reads_by_name(bracken_output, args.host_name)
    pathogen_reads = get_estimated_reads_by_name(bracken_output, args.pathogen_name)
    other_reads = total_reads - host_reads - pathogen_reads
    analysis_stage = args.analysis_stage
    sample_id = args.sample_id

    output = [
        {
            'sample_id': sample_id,
            'pathogen_reads_' + analysis_stage: pathogen_reads,
            'host_reads_' + analysis_stage: host_reads,
            'other_reads_' + analysis_stage: other_reads,
        },
    ]

    output_fieldnames = [
        'sample_id',
        'pathogen_reads_'+ analysis_stage,
        'host_reads_' + analysis_stage,
        'other_reads_'+ analysis_stage,
    ]

    csv.register_dialect('unix-tab', delimiter='\t', doublequote=False, lineterminator='\n', quoting=csv.QUOTE_MINIMAL)
    writer = csv.DictWriter(sys.stdout, fieldnames=output_fieldnames, dialect='unix-tab')

    writer.writeheader()
    
    for row in output:
        writer.writerow(row)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--sample_id')
    parser.add_argument('--host_name')
    parser.add_argument('--pathogen_name')
    parser.add_argument('--analysis_stage')
    parser.add_argument('bracken_output')

    args = parser.parse_args()
    main(args)
