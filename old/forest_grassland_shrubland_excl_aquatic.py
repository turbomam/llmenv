from oaklib import get_adapter

# Initialize the adapter
adapter = get_adapter('sqlite:obo:envo')

# Define the major biomes
major_biomes = [
    'ENVO:00000446',  # terrestrial biome
    'ENVO:01000339',  # polar biome (representing climate-related biomes)
    'ENVO:01000219',  # anthropogenic terrestrial biome
    'ENVO:01000174',  # forest biome
    'ENVO:01000177',  # grassland biome
    'ENVO:01000176',  # shrubland biome
    'ENVO:01000175',  # woodland biome
    'ENVO:01000179',  # desert biome
    'ENVO:01000180',  # tundra biome
]


def get_biomes():
    biomes = set()

    for biome in major_biomes:
        # Use descendants to get all subclasses (including self)
        biomes.update(adapter.descendants(biome, reflexive=True))

    # Remove aquatic biomes
    aquatic_biomes = set(adapter.descendants('ENVO:00000447', reflexive=True))  # marine biome
    aquatic_biomes.update(adapter.descendants('ENVO:00000873', reflexive=True))  # freshwater biome
    biomes = biomes - aquatic_biomes

    return biomes


# Get the biomes and their labels
biomes = get_biomes()
result = [(biome, adapter.label(biome)) for biome in biomes]

# Sort and print the results
for biome, label in sorted(result, key=lambda x: x[1]):
    print(f"{biome},{label}")
