from oaklib import get_adapter


def find_descendants(term_id, adapter, include_self=False):
    descendants = set(adapter.descendants(term_id, reflexive=include_self))
    return descendants


def get_biomes(adapter):
    biomes = set()

    # Major biome categories
    major_biomes = [
        'ENVO:00000446',  # terrestrial biome
        'ENVO:01000339',  # polar biome (representing climate-related biomes)
        'ENVO:01000219',  # anthropogenic terrestrial biome
    ]

    for biome in major_biomes:
        biomes.update(find_descendants(biome, adapter, include_self=True))

    # Remove aquatic biomes
    aquatic_biomes = find_descendants('ENVO:00000447', adapter)  # marine biome
    aquatic_biomes.update(find_descendants('ENVO:00000873', adapter))  # freshwater biome
    biomes = biomes - aquatic_biomes

    return biomes


if __name__ == "__main__":
    ontology_db_string = "sqlite:obo:envo"
    adapter = get_adapter(ontology_db_string)

    biomes = get_biomes(adapter)

    print("EnvBroadScaleSoilEnum:")
    for biome in sorted(biomes):
        label = adapter.label(biome)
        print(f"{label} [{biome}]")
