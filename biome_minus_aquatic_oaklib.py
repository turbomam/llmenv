from oaklib import get_adapter

# Initialize the adapter
adapter = get_adapter('sqlite:obo:envo')

# Define the major biomes
include_roots = [
    'ENVO:00000428',  # biome
]

exclude_roots = [
    'ENVO:00002030'  # aquatic biome
]


def get_final_classes():
    starting_classes = set(adapter.descendants(start_curies=include_roots, predicates=['rdfs:subClassOf'],
                                               reflexive=True))

    excluded_classes = set(adapter.descendants(start_curies=exclude_roots, predicates=['rdfs:subClassOf'],
                                               reflexive=True))

    final_classes = starting_classes - excluded_classes

    return final_classes


# Get the biomes and their labels
final_classes = get_final_classes()
final_labelled = [(onto_class, adapter.label(onto_class)) for onto_class in final_classes]

# Sort and print the results
for class_id, label in sorted(final_labelled, key=lambda x: x[0]):
    print(f"{class_id}\t{label}")
