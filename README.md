system requirements:
- go
- yamlfmt
- robot
- wget
- yq (Mike Farah/GO)

----

- add oaklib as python dependency?
- try litellm instead of llm?
- extract Extensions with linkml-map instead of yq?


```shell
# this runoak command doesn't require downloading the EnvO RDF/XML OWL from GitHub
# CJM would alias as alias envo="runoak -i obo:sqlite:envo"

runoak set-apikey --endpoint bioportal <SECRET>

runoak cache-ls

runoak --input sqlite:obo:envo info 'biome'
runoak --input sqlite:obo:envo aliases 'biome'
runoak --input sqlite:obo:envo ancestors 'biome'
runoak --input sqlite:obo:envo axioms 'biome' # NotImplementedError requires OFN
runoak --input sqlite:obo:envo definitions 'biome' 
runoak --input sqlite:obo:envo descendants 'biome' 
runoak --input sqlite:obo:envo disjoints 'biome' --autolabel -O csv # biome is disjoint from both ecoregion and ecozone # additional single-blank-node disjoints?!
runoak --input sqlite:obo:envo labels 'biome' 
runoak --input sqlite:obo:envo languages
runoak --input sqlite:obo:envo leafs
runoak --input sqlite:obo:envo obsoletes
runoak --input bioportal: ontology-metadata envo
runoak --input bioportal: ontology-versions envo
runoak --input sqlite:obo:envo paths  -p i,p biosphere 'polar biome' # reports results but then says no paths found
runoak --input sqlite:obo:envo prefixes
runoak --input sqlite:obo:envo relationships .desc//p=i ENVO:00000428 > biome-relationships.tsv # !!! pivot? include entailment? --include-entailed / --no-include-entailed; --non-redundant-entailed / --no-non-redundant-entailed
runoak --input sqlite:obo:envo roots # why are hail and CL:0000000 reported?
runoak --input bioportal: search biome
runoak --input sqlite:obo:envo siblings 'aquatic biome'
runoak --input sqlite:obo:envo singletons
runoak --input sqlite:obo:envo statistics # ERRORS
runoak --input sqlite:obo:envo subsets # output and ERRORS
runoak --input sqlite:obo:envo term-categories biome # nothing
runoak --input sqlite:obo:envo term-metadata .desc//p=i ENVO:00000428 > biome-metadata.yaml # !!! try different formats? or predicate list?
runoak --input sqlite:obo:envo term-subsets biome # nothing
runoak --input sqlite:obo:envo terms
runoak --input sqlite:obo:envo tree  biome # up by default
runoak --input sqlite:obo:envo usages  biome

```


skipped
- cache-clear
- annotate
- apply 
- apply-obsolete
- apply-taxon-constraints
- associations
- associations-counts
- associations-matrix
- diff
- diff-associations
- diff-terms
- diff-via-mappings
- dump
- enrichment
- expand-subsets # WARNING:root:Subset may be incorrectly encoded as value for envoPolar # subset  term    subset_termValueError: Subset envoPolar not found in ...
- EXTRACT
- fill-table
- generate-definitions
- generate-disjoints
- generate-lexical-replacements
- generate-logical-definitions
- generate-synonyms
- information-content
- lexmatch
- lint
- logical-definitions
- mappings
- migrate-curies 
- normalize
- ontologies
- QUERY
- rollup
- similarity 
- similarity-pair
- synonymize # Deprecated: use generate-synonyms
- taxon-constraints
- termset-similarity
- transform
- validate
- validate-definitions
- validate-mappings
- validate-multiple
- validate-synonyms
