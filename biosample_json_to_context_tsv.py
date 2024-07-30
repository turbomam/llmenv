import json
import csv
from typing import Dict, Any, List
import click


@click.command()
@click.option('--input-file', '-i', type=click.Path(exists=True), required=True,
              help='Path to the input JSON file containing biosample data.')
@click.option('--output-file', '-o', type=click.Path(), required=True,
              help='Path to the output TSV file to be created.')
def create_biosample_table(input_file: str, output_file: str) -> None:
    """
    Create a TSV table of biosample data from a JSON file.

    This script reads a JSON file containing biosample data and creates a TSV (Tab-Separated Values)
    file with selected fields for each biosample. The environmental scale fields use term.id for values
    and prefer term.name (falling back to has_raw_value) for labels.
    """
    with open(input_file, 'r') as file:
        data: Dict[str, Any] = json.load(file)

    fieldnames: List[str] = [
        'id', 'insdc_biosample_identifiers',
        'env_broad_scale_id', 'env_broad_scale_label',
        'env_local_scale_id', 'env_local_scale_label',
        'env_medium_id', 'env_medium_label'
    ]

    with open(output_file, 'w', newline='') as tsvfile:
        writer = csv.DictWriter(tsvfile, fieldnames=fieldnames, delimiter='\t')

        writer.writeheader()

        biosamples_written = 0
        for biosample in data['resources']:
            insdc_identifiers = biosample.get('insdc_biosample_identifiers', [])
            row: Dict[str, str] = {
                'id': biosample['id'],  # id is required and always present
                'insdc_biosample_identifiers': '|'.join(insdc_identifiers) if insdc_identifiers else '',
                'env_broad_scale_id': biosample['env_broad_scale']['term']['id'],
                'env_broad_scale_label': biosample['env_broad_scale']['term'].get('name', biosample['env_broad_scale'][
                    'has_raw_value']),
                'env_local_scale_id': biosample['env_local_scale']['term']['id'],
                'env_local_scale_label': biosample['env_local_scale']['term'].get('name', biosample['env_local_scale'][
                    'has_raw_value']),
                'env_medium_id': biosample['env_medium']['term']['id'],
                'env_medium_label': biosample['env_medium']['term'].get('name',
                                                                        biosample['env_medium']['has_raw_value'])
            }
            writer.writerow(row)
            biosamples_written += 1

    click.echo(f"TSV file has been created: {output_file}")
    click.echo(f"Total biosamples written: {biosamples_written}")


if __name__ == '__main__':
    create_biosample_table()
