import click
import pandas as pd
from typing import Tuple, Optional
from pathlib import Path

pd.set_option('display.max_columns', None)


@click.command()
@click.option('--keep-file', type=click.Path(exists=True), required=True, help='Path to the keep CSV file')
@click.option('--reference-file', type=click.Path(exists=True), required=True, help='Path to the reference CSV file')
@click.option('--keep-key', type=str, required=True,
              help='Name of the key column in keep file for merging and null/blank check')
@click.option('--reference-key', type=str, required=True,
              help='Name of the key column in reference file for merging and null/blank check')
@click.option('--reference-addition', type=str, required=True,
              help='Name of the additional column from reference file to include in merge')
@click.option('--addition-rename', type=str, required=True,
              help='')
@click.option('--merged-file', type=click.Path(), required=True, help='Path to save the merged CSV file')
def process_csvs(keep_file: str, reference_file: str, keep_key: str, reference_key: str, reference_addition: str,
                 merged_file: str, addition_rename: str) -> None:
    """
    Read two CSV files (keep and reference), split each based on whether specified key columns are null or blank,
    merge the non-null DataFrames with a specified additional column from the reference file,
    add back null rows from the keep file, and save the result.

    Args:
        keep_file (str): Path to the keep CSV file.
        reference_file (str): Path to the reference CSV file.
        keep_key (str): Name of the key column in keep file for merging and null/blank check.
        reference_key (str): Name of the key column in reference file for merging and null/blank check.
        reference_addition (str): Name of the additional column from reference file to include in merge.
        merged_file (str): Path to save the merged CSV file.

    Returns:
        None
    """
    # Process keep file
    keep_notnull, keep_null = process_file(keep_file, keep_key, "keep")

    print(keep_notnull)
    print(keep_null)

    reference_notnull, reference_null = process_file(reference_file, reference_key, "keep")
    reference_notnull = reference_notnull.rename(columns={reference_addition: addition_rename})

    reference_notnull = reference_notnull[[reference_key, addition_rename]]

    print(reference_notnull)
    print(reference_null)

    merged_df = pd.merge(keep_notnull, reference_notnull, left_on=keep_key, right_on=reference_key, how='left')
    print(merged_df)

    final_df = pd.concat([merged_df, keep_null], ignore_index=True)

    print(final_df)

    final_df.to_csv(merged_file, index=False)

    # # Process reference file
    # reference_df = pd.read_csv(reference_file)
    # reference_notnull = reference_df[reference_df[reference_key].notna() & (reference_df[reference_key] != '')]
    #
    # # Limit reference DataFrame to specified columns
    # reference_notnull = reference_notnull[[reference_key, reference_addition]]
    #
    # # Merge non-null DataFrames
    # merged_df = pd.merge(keep_notnull, reference_notnull, left_on=keep_key, right_on=reference_key, how='left')
    #
    # # Remove the duplicate column from the merge, but keep the normalized_curie
    # merged_df = merged_df.drop(columns=[reference_key])
    #
    # # Add back null rows from keep file
    # final_df = pd.concat([merged_df, keep_null], ignore_index=True)
    #
    # # Save the merged file
    # # final_df.to_csv(merged_file, index=False)
    #
    # click.echo(f"Merged file saved to {merged_file}")


def process_file(input_file: str, key_column: str, file_type: str) -> Tuple[
    pd.DataFrame, pd.DataFrame]:
    """
    Process a single CSV file: read and split based on the key column.

    Args:
        input_file (str): Path to the input CSV file.
        key_column (str): Name of the key column to check for null/blank values.
        file_type (str): Type of file (keep or reference) for logging purposes.

    Returns:
        Tuple[pd.DataFrame, pd.DataFrame]: Two DataFrames, one with non-null values and one with null values.
    """
    # Read the CSV file
    df = pd.read_csv(input_file)

    # Check for normalized_curie column if it's the keep file
    if file_type == "keep" and key_column not in df.columns:
        raise ValueError("normalized_curie column not found in the keep file")

    # Split the DataFrame
    df_notnull, df_null = split_dataframe(df, key_column)

    click.echo(f"Split completed for {file_type} file.")

    return df_notnull, df_null


def split_dataframe(df: pd.DataFrame, key_column: str) -> Tuple[pd.DataFrame, pd.DataFrame]:
    """
    Split a DataFrame into two based on whether a specified key column is null or blank.

    Args:
        df (pd.DataFrame): Input DataFrame.
        key_column (str): Name of the key column to check for null/blank values.

    Returns:
        Tuple[pd.DataFrame, pd.DataFrame]: Two DataFrames, one with non-null values and one with null values.
    """
    # Check if the column exists in the DataFrame
    if key_column not in df.columns:
        raise ValueError(f"Key column '{key_column}' not found in the DataFrame")

    # Split the DataFrame
    df_notnull = df[df[key_column].notna() & (df[key_column] != '')]
    df_null = df[df[key_column].isna() | (df[key_column] == '')]

    return df_notnull, df_null


if __name__ == '__main__':
    process_csvs()
