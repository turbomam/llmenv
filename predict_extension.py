import json
import csv
from collections import defaultdict, Counter

# Load the extension slots data
with open('mixs_extensions_with_slots.json', 'r') as file:
    extensions_data = json.load(file)

# Calculate the frequency of each slot across all extensions to determine their significance
slot_frequencies = Counter()
for extension, details in extensions_data.items():
    slot_frequencies.update(details['slots'])

# Load the biosamples data
with open('nmdc_production_biosamples.json', 'r') as file:
    biosamples = json.load(file)['resources']


# Function to score and predict the best matching extension for each biosample
def predict_extension(biosample):
    scores = defaultdict(float)
    sample_slots = set(biosample.keys())

    for extension, details in extensions_data.items():
        for slot in details['slots']:
            if slot in sample_slots:
                # Weighting by inverse frequency (less frequent slots have higher significance)
                scores[extension] += 1 / slot_frequencies[slot]

    # Return the extension with the highest score
    return max(scores, key=scores.get) if scores else None


# Prepare data for CSV output
data_to_write = []
for sample in biosamples:
    extension_prediction = predict_extension(sample)
    studies = sample.get('part_of', [])
    if not isinstance(studies, list):
        studies = [studies]
    data_to_write.append({
        'biosample_id': sample['id'],
        'studies': ', '.join(studies),
        'predicted_extension': extension_prediction if extension_prediction else "Unknown"
    })

# Write to TSV file using csv.DictWriter
with open('biosample_extension_predictions.tsv', 'w', newline='') as file:
    fieldnames = ['biosample_id', 'studies', 'predicted_extension']
    writer = csv.DictWriter(file, fieldnames=fieldnames, delimiter='\t')
    writer.writeheader()
    writer.writerows(data_to_write)

print("Predictions have been written to 'biosample_extension_predictions.tsv'.")
