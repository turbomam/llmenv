import json

# Load the JSON data from the file
with open('mixs_extensions_with_slots.json', 'r') as file:
    data = json.load(file)

# Dictionary to store all slots across extensions for comparison
all_slots = {}

# Populate the all_slots dictionary with counts of occurrences for each slot
for extension, details in data.items():
    for slot in details['slots']:
        if slot in all_slots:
            all_slots[slot] += 1
        else:
            all_slots[slot] = 1

# Dictionary to store unique slots for each extension
unique_slots_per_extension = {}

# Populate unique_slots_per_extension with slots that only appear once in all_slots
for extension, details in data.items():
    unique_slots = [slot for slot in details['slots'] if all_slots[slot] == 1]
    unique_slots_per_extension[extension] = sorted(unique_slots)

# Sort the extensions dictionary
sorted_extensions = dict(sorted(unique_slots_per_extension.items()))

# Save the sorted unique slots per extension into a JSON file
with open('sorted_unique_slots_per_extension.json', 'w') as outfile:
    json.dump(sorted_extensions, outfile, indent=4)
