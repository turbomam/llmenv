YAMLFMT_PATH = ./yamlfmt # installed locally on Ubuntu... may be easier to install system-wide on other platforms

RUN = poetry run
envo.owl:
	wget https://raw.githubusercontent.com/EnvironmentOntology/envo/v2024-07-01/envo.owl
	# subset with robot extract? may still be very large # summarize with oaklib

envo.ttl: envo.owl
	robot convert --input $< --output $@
	# more amenable to processing with LLMs? But still too big!

envo.ofn: envo.owl
	robot convert --input $< --output $@
	# for runoak axioms?

envo.json: envo.owl
	robot convert --input $< --output $@
	# process with yq or jq? # would leave danglers

mixs.yaml:
	# preferable to use a tagged release, but theres good stuff in this commit that hasn't been released yet
	wget https://raw.githubusercontent.com/GenomicsStandardsConsortium/mixs/b0b1e03b705cb432d08914c686ea820985b9cb20/src/mixs/schema/mixs.yaml

mixs_extensions.yaml: mixs.yaml
	yq e '.classes | with_entries(select(.value.is_a == "Extension") | .value |= del(.slots, .slot_usage))' $< | cat > $@
	$(YAMLFMT_PATH) $@ # overwrites; # configured with .yamlfmt

biome-relationships.tsv:
	$(RUN) runoak --input sqlite:obo:envo relationships .desc//p=i ENVO:00000428 > $@
	# !!! pivot? include entailment? --include-entailed / --no-include-entailed; --non-redundant-entailed / --no-non-redundant-entailed
	# LLM web interfaces might want CSVs

biome-relationships.csv: biome-relationships.tsv
	sed 's/\t/,/g' $< > $@
	#awk 'BEGIN {FS="\t"; OFS=","} {print $$0}' $< > $@

biome-metadata.yaml:
	$(RUN) runoak --input sqlite:obo:envo term-metadata .desc//p=i ENVO:00000428 > $@
	 # !!! try different formats? or predicate list?

biome-metadata.json: biome-metadata.yaml
	yq ea '[.]' $< -o=json | cat > $@

env_broad_scale.json: mixs.yaml
	yq '.slots.env_broad_scale' -o=json $< | cat > $@