import oaklib
from oaklib import get_implementation_from_shorthand


def find_descendants(term_id, ontology_db, include_self=False):
    oi = get_implementation_from_shorthand(ontology_db) # /home/mark/PycharmProjects/llmenv/from_chatgpt.py:6: DeprecatedWarning: get_implementation_from_shorthand is deprecated as of Use get_adapter instead. oi = get_implementation_from_shorthand(ontology_db)
    descendants = set(oi.descendants(term_id, reflexive=include_self))
    return descendants


def get_biomes(ontology_db):
    oi = get_implementation_from_shorthand(ontology_db)
    biomes = set()

    # Major biome categories
    major_biomes = [
        'ENVO:00000446',  # terrestrial biome
        'ENVO:01000339',  # polar biome (representing climate-related biomes)
        'ENVO:01000219',  # anthropogenic terrestrial biome
    ]

    for biome in major_biomes:
        biomes.update(find_descendants(biome, ontology_db, include_self=True))

    # Remove aquatic biomes
    aquatic_biomes = find_descendants('ENVO:00000447', ontology_db)  # marine biome
    aquatic_biomes.update(find_descendants('ENVO:00000873', ontology_db))  # freshwater biome
    biomes = biomes - aquatic_biomes

    return biomes


if __name__ == "__main__":
    ontology_db = "sqlite:obo:envo"
    oi = get_implementation_from_shorthand(ontology_db)

    biomes = get_biomes(ontology_db)

    print("EnvBroadScaleSoilEnum:")
    for biome in sorted(biomes):
        label = oi.label(biome)
        print(f"{label} [{biome}]")
