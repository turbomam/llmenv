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


# getting fragments of EnvO because the whole thing is too large to feed into an LLM
# our guideline is that env_broad_scale should be answered with an EnvO biome subclass
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

# our guideline is that env_medium should be answered with an EnvO biome subclass
environmental-materials-relationships.tsv:
	$(RUN) runoak --input sqlite:obo:envo relationships .desc//p=i ENVO:00010483 > $@

environmental-materials-relationships.csv: environmental-materials-relationships.tsv
	sed 's/\t/,/g' $< > $@

environmental-materials-metadata.yaml:
	$(RUN) runoak --input sqlite:obo:envo term-metadata .desc//p=i ENVO:00010483 > $@

environmental-materials-metadata.json: environmental-materials-metadata.yaml
	yq ea '[.]' $< -o=json | cat > $@

# the guidance for env_local_scale is less concreted so I am skipping for now.

####

mixs.yaml:
	# preferable to use a tagged release, but theres good stuff in this commit that hasn't been released yet
	wget https://raw.githubusercontent.com/GenomicsStandardsConsortium/mixs/b0b1e03b705cb432d08914c686ea820985b9cb20/src/mixs/schema/mixs.yaml

mixs.json: mixs.yaml
	yq '.' -o=json $< | jq -c | cat > $@

# getting fragments of MIxS because the whole thing is too large to feed into an LLM
mixs_extensions_with_slots.json: mixs.yaml
	yq -o=json e '.classes | with_entries(select(.value.is_a == "Extension") | .value |= del(.slot_usage))' $< | cat > $@

mixs_extensions.yaml: mixs.yaml
	yq e '.classes | with_entries(select(.value.is_a == "Extension") | .value |= del(.slots, .slot_usage))' $< | cat > $@
	$(YAMLFMT_PATH) $@ # overwrites; # configured with .yamlfmt

mixs_extensions.json: mixs_extensions.yaml
	yq '.' -o=json $< | cat > $@

mixs_env_triad.json: mixs.yaml
	yq e -o=json '{"slots": {"env_broad_scale": .slots.env_broad_scale, "env_local_scale": .slots.env_local_scale, "env_medium": .slots.env_medium}}' $< | cat > $@


####

# get fragments of the NMDC schema(s)
nmdc_materialized_patterns.yaml:
	wget https://raw.githubusercontent.com/microbiomedata/nmdc-schema/v10.7.0/nmdc_schema/nmdc_materialized_patterns.yaml

nmdc_submission_schema.yaml:
	wget https://raw.githubusercontent.com/microbiomedata/submission-schema/v10.7.0/src/nmdc_submission_schema/schema/nmdc_submission_schema.yaml

established_value_sets_from_schema.json: nmdc_submission_schema.yaml
	yq -o=json \
	'{"enums": {"EnvBroadScaleSoilEnum": .enums.EnvBroadScaleSoilEnum, "EnvLocalScaleSoilEnum": .enums.EnvLocalScaleSoilEnum, "EnvMediumSoilEnum": .enums.EnvMediumSoilEnum}}' \
	$< | cat > $@ # ~ 48


# get fragments of the NMDC production MongoDB Study and Biosample contents
nmdc_production_studies.json:
	wget -O $@.bak https://api.microbiomedata.org/nmdcschema/study_set?max_page_size=999999
	yq '.' -o=json $@.bak | cat > $@
	rm -rf $@.bak

nmdc_production_biosamples.json:
	wget -O $@ https://api.microbiomedata.org/nmdcschema/biosample_set?max_page_size=999999
	yq '.' -o=json $@ | cat > $@.pretty.json

nmdc_production_biosamples_5pct.json: nmdc_production_biosamples.json
	$(RUN) python random_sample_resources.py \
		--input_file $< \
		--output_file $@ \
		--sample_percentage 5

nmdc_production_biosamples_env_package.json:
	curl -X 'GET' \
		'https://api.microbiomedata.org/nmdcschema/biosample_set?max_page_size=999999&projection=env_package' \
		-H 'accept: application/json' > $@
	yq '.' -o=json $@ | cat > $@.pretty.json # ENVO:00001998is also soil

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

sty-11-zs2syx06_biosample_json_to_context.tsv: sty-11-zs2syx06_biosamples.json
	$(RUN) python biosample_json_to_context_tsv.py \
		--input-file $< \
		--output-file $@

nmdc_production_biosamples_json_to_context.tsv: nmdc_production_biosamples.json
	$(RUN) python biosample_json_to_context_tsv.py \
		--input-file $< \
		--output-file $@

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

biome_minus_aquatic_runoak.txt:
	$(RUN) runoak --input sqlite:obo:envo info .desc//p=i ENVO:00000428  .not .desc//p=i ENVO:00002030 > $@ # ~ 72

envo_info.txt:
	$(RUN) runoak --input sqlite:obo:envo info  .desc//p=i continuant > $@

envo_info.csv: envo_info.txt
	$(RUN) python normalize_envo_data.py \
			--input-file $< \
			--ontology-prefix ENVO \
			--output-file $@

biome_minus_aquatic_runoak.tsv:
	$(RUN) runoak --input sqlite:obo:envo info --output-type tsv  .desc//p=i ENVO:00000428 .not .desc//p=i ENVO:00002030  > $@

clean: clean-intermediates
	rm -rf *.csv *.owl *.ttl *.ofn *.json

clean-intermediates:
	#mv filename-to-content-prompt-specification.yaml filename-to-content-prompt-specification.yaml.keep
	rm -rf *.tsv *.yaml
	#mv filename-to-content-prompt-specification.yaml.keep filename-to-content-prompt-specification.yaml

####

# never_clean/filename-to-content-prompt-specification.yaml

filename-to-content-prompt.txt: never_clean/biome-minus-aquatic-vs-established.yaml
	$(RUN) python filename-to-content-prompt.py \
		--spec_file_path $< \
		--output_file_path $@


llm-response.md: filename-to-content-prompt.txt
	cat $< | $(RUN) llm prommpt --model gpt-4o  -o temperature 0.01 | tee $@

# -o temperature 0.01

#OpenAI Chat: gpt-3.5-turbo (aliases: 3.5, chatgpt)
#OpenAI Chat: gpt-3.5-turbo-16k (aliases: chatgpt-16k, 3.5-16k)
#OpenAI Chat: gpt-4 (aliases: 4, gpt4)
#OpenAI Chat: gpt-4-32k (aliases: 4-32k)
#OpenAI Chat: gpt-4-1106-preview
#OpenAI Chat: gpt-4-0125-preview
#OpenAI Chat: gpt-4-turbo-2024-04-09
#OpenAI Chat: gpt-4-turbo (aliases: gpt-4-turbo-preview, 4-turbo, 4t)
#OpenAI Chat: gpt-4o (aliases: 4o)
#OpenAI Chat: gpt-4o-mini (aliases: 4o-mini)
#OpenAI Completion: gpt-3.5-turbo-instruct (aliases: 3.5-instruct, chatgpt-instruct)
#GeminiPro: gemini-pro
#GeminiPro: gemini-1.5-pro-latest
#GeminiPro: gemini-1.5-flash-latest
#Anthropic Messages: claude-3-opus-20240229 (aliases: claude-3-opus)
#Anthropic Messages: claude-3-sonnet-20240229 (aliases: claude-3-sonnet)
#Anthropic Messages: claude-3-haiku-20240307 (aliases: claude-3-haiku)
#Anthropic Messages: claude-3-5-sonnet-20240620 (aliases: claude-3.5-sonnet)


all: clean biome-relationships.csv biome-metadata.json \
environmental-materials-relationships.csv environmental-materials-metadata.json \
mixs_extensions.json mixs_extensions_with_slots.json \
mixs_env_triad.json \
established_value_sets_from_schema.json nmdc_production_studies.json nmdc_production_biosamples.json \
nmdc_production_biosamples_5pct.json nmdc_production_biosamples_json_to_context.tsv \
biome_minus_aquatic_rq.tsv biome_minus_aquatic_oaklib.tsv biome_minus_aquatic_runoak.tsv


nmdc_submission_schema_enums_keys.txt: nmdc_submission_schema.yaml
	yq eval '.enums | keys | .[]' $< | sort  > $@


EnvBroadScaleSoilEnum.pvs_keys.txt: nmdc_submission_schema.yaml
	yq eval '.enums.EnvBroadScaleSoilEnum.permissible_values | keys | .[]' $< | cat > $@

bioproject.xml: # 3 GB; 2 minutes at 30MB/s
	wget https://ftp.ncbi.nlm.nih.gov/bioproject/bioproject.xml

biosample_set.xml.gz:
	wget https://ftp.ncbi.nlm.nih.gov/biosample/biosample_set.xml.gz

biosample_set.xml: biosample_set.xml.gz
	# keep original
	gunzip -k $<

ncbi_biosamples_context_value_counts.csv:
	$(RUN) python count_biosample_context_vals_from_postgres.py \
		--output-file $@

ncbi_biosamples_context_value_counts_normalized.csv: ncbi_biosamples_context_value_counts.csv
	$(RUN) python normalize_envo_data.py \
		--count-col-name total_count \
		--input-file $< \
		--ontology-prefix ENVO \
		--output-file $@ \
		--val-col-name value

ncbi_biosamples_context_value_counts_failures.csv: ncbi_biosamples_context_value_counts_normalized.csv
	$(RUN) python find_envo_present_no_curie_extracted.py \
		--input-file $< \
		--output-file $@

ncbi_biosamples_context_value_counts_real_labels.csv:
	$(RUN) python merge_in_reference_data.py \
		--keep-file ncbi_biosamples_context_value_counts_normalized.csv \
		--keep-key normalized_curie \
		--reference-file envo_info.csv \
		--reference-key normalized_curie \
		--reference-addition normalized_label \
		--addition-rename real_label \
		--merged-file $@