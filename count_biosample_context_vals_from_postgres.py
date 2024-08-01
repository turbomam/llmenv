import csv
import os
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
import click
from typing import List, Tuple

# Load environment variables from .env file
load_dotenv('local/.env')


@click.command()
@click.option('--output-file', type=str, default='ncbi_biosamples_context_value_counts.csv',
              help='Output CSV file name.')
def main(output_file: str) -> None:
    """
    Main function to fetch and write data.

    Args:
        output_file: The name of the CSV file to output the data to.
    """
    database_url = os.getenv('BIOSAMPLES_PG_DATABASE_URL')
    if database_url is None:
        raise ValueError("BIOSAMPLES_PG_DATABASE_URL is not set in the environment.")

    # Create a database connection using the URL directly
    engine = create_engine(database_url)

    data = fetch_data(engine)
    write_to_csv(data, output_file)
    print(f"Data has been successfully written to {output_file}")


def fetch_data(engine) -> List[Tuple[str, int]]:
    """
    Fetch summarized data from the PostgreSQL biosamples database.

    Args:
        engine: SQLAlchemy database engine.

    Returns:
        List of tuples containing the value and its total count.
    """
    query = text("""
    SELECT
        value,
        COUNT(value) AS total_count
    FROM
        (
        SELECT env_broad_scale AS value FROM attributes_plus WHERE env_broad_scale IS NOT NULL
        UNION ALL
        SELECT env_local_scale AS value FROM attributes_plus WHERE env_local_scale IS NOT NULL
        UNION ALL
        SELECT env_medium AS value FROM attributes_plus WHERE env_medium IS NOT NULL
        ) AS unified_values
    GROUP BY
        value
    HAVING
        COUNT(value) >= 2
    ORDER BY
        total_count DESC;
    """)

    with engine.connect() as connection:
        result = connection.execute(query)
        return result.fetchall()


def write_to_csv(data: List[Tuple[str, int]], filename: str) -> None:
    """
    Write data to a CSV file.

    Args:
        data: A list of tuples containing the value and its total count.
        filename: The name of the CSV file to write the data to.
    """
    with open(filename, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['value', 'total_count'])
        writer.writerows(data)


if __name__ == "__main__":
    main()
