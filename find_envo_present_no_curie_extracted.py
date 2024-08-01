import pandas as pd

# Read the CSV file
df = pd.read_csv('normalized_data.csv')

# Apply the filter
filtered_df = df[
    df['portion_parsed'].str.contains('envo', case=False, na=False) &
    ~df['normalized_curie'].str.contains('ENVO:', na=False)
]

# Display the filtered rows
print(filtered_df)

# Optionally, save to a new CSV file
filtered_df.to_csv('filtered_output.csv', index=False)