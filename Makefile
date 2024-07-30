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

####

mixs.yaml:
	# preferable to use a tagged release, but theres good stuff in this commit that hasn't been released yet
	wget https://raw.githubusercontent.com/GenomicsStandardsConsortium/mixs/b0b1e03b705cb432d08914c686ea820985b9cb20/src/mixs/schema/mixs.yaml

mixs_extensions.yaml: mixs.yaml
	yq e '.classes | with_entries(select(.value.is_a == "Extension") | .value |= del(.slots, .slot_usage))' $< | cat > $@
	$(YAMLFMT_PATH) $@ # overwrites; # configured with .yamlfmt

mixs_extensions.json: mixs_extensions.yaml
	yq '.' -o=json $< | cat > $@

env_broad_scale.json: mixs.yaml
	yq '.slots.env_broad_scale' -o=json $< | cat > $@

####

nmdc_materialized_patterns.yaml:
	wget https://raw.githubusercontent.com/microbiomedata/nmdc-schema/v10.7.0/nmdc_schema/nmdc_materialized_patterns.yaml

nmdc_submission_schema.yaml:
	wget https://raw.githubusercontent.com/microbiomedata/submission-schema/v10.7.0/src/nmdc_submission_schema/schema/nmdc_submission_schema.yaml

established_value_sets_from_schema.json: nmdc_submission_schema.yaml
	yq -o=json \
	'{"enums": {"EnvBroadScaleSoilEnum": .enums.EnvBroadScaleSoilEnum, "EnvLocalScaleSoilEnum": .enums.EnvLocalScaleSoilEnum, "EnvMediumSoilEnum": .enums.EnvMediumSoilEnum}}' \
	$< | cat > $@ # ~ 48

nmdc_production_studies.json:
	wget -O $@.bak https://api.microbiomedata.org/nmdcschema/study_set?max_page_size=999999
	yq '.' -o=json $@.bak | cat > $@
	rm -rf $@.bak

nmdc_production_biosamples.json:
	wget -O $@ https://api.microbiomedata.org/nmdcschema/biosample_set?max_page_size=999999
	yq '.' -o=json $@ | cat > $@.pretty.json


sty-11-33fbta56_biosamples.json:
	wget -O $@ https://api.microbiomedata.org/nmdcschema/biosample_set?filter=%7B%22part_of%22%3A%22nmdc%3Asty-11-33fbta56%22%7D&max_page_size=999999

sty-11-dcqce727_biosamples.json:
	wget -O $@ https://api.microbiomedata.org/nmdcschema/biosample_set?filter=%7B%22part_of%22%3A%22nmdc%3Asty-11-dcqce727%22%7D&max_page_size=999999

sty-11-zs2syx06_biosamples.json: # doesn't work with wget ?!?!?!
	curl -X 'GET' \
		'https://api.microbiomedata.org/nmdcschema/biosample_set?filter=%7B%22part_of%22%3A%22nmdc%3Asty-11-zs2syx06%22%7D&max_page_size=999999' \
		-H 'accept: application/json' > $@

sty-11-zs2syx06_study.json: # doesn't work with wget ?!?!?!
	curl -X 'GET' \
		'https://api.microbiomedata.org/nmdcschema/ids/nmdc%3Asty-11-zs2syx06' \
		-H 'accept: application/json' > $@


# soil studies recommended by Montana:
# - https://data.microbiomedata.org/details/study/nmdc:sty-11-dcqce727 see doi:10.1371/journal.pone.0228165
#     https://api.microbiomedata.org/nmdcschema/biosample_set?filter=%7B%22part_of%22%3A%22nmdc%3Asty-11-dcqce727%22%7D&max_page_size=999999
# - https://data.microbiomedata.org/details/study/nmdc:sty-11-33fbta56 see doi:10.1128/mSystems.00045-18
# claude recommended https://data.microbiomedata.org/details/study/nmdc:sty-11-zs2syx06 but Montana says that the metadata wasnt curated, and there's no journal article?


####

#forest_grassland_shrubland_excl_aquatic_py.csv:
#	$(RUN) runoak --input sqlite:obo:envo term-metadata .desc//p=i ENVO:01000255 ENVO:01000256 ENVO:01000257 ENVO:01000258 ENVO:01000259 > $@
#	# !!! pivot? include entailment? --include-entailed / --no-include-entailed; --non-redundant-entailed / --no-non-redundant-entailed
#	# LLM web interfaces might want CSVs

# sparql
biome_minus_aquatic_rq.tsv: biome_minus_aquatic.rq
	$(RUN) runoak --input ubergraph: query --output $@ --query "$$(cat $<)" # ~ 72 without named graph constraint

# oaklib
biome_minus_aquatic_oaklib.tsv:
	$(RUN) python biome_minus_aquatic_oaklib.py > $@ # ~ 72 classes

biome_minus_aquatic_runoak.tsv:
	$(RUN) runoak --input sqlite:obo:envo info .desc//p=i ENVO:00000428  .not .desc//p=i ENVO:00002030 > $@ # ~ 72

clean: clean-intermediates
	rm -rf *.csv *.owl *.ttl *.ofn *.json

clean-intermediates:
	rm -rf *.tsv *.yaml

all: clean biome-relationships.csv biome-metadata.json mixs_extensions.json env_broad_scale.json established_subset_enums.json