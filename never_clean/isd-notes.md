https://www.ncbi.nlm.nih.gov/biosample/13478212
Accession: SAMEA104726483 ID: 13478212
description.paragraph = ['metagenome from Crete soil'] (ish)
BioProject PRJEB21776
title = Crete soil metagenome

package = 'Generic.1.0'
why generic package?!
submitted to ENA because samples came from Greece?
what version?
December 2019
poor harmonization of currently required fields

https://www.ebi.ac.uk/biosamples/samples/SAMEA104726483
https://www.ebi.ac.uk/biosamples/samples/SAMEA104726483.json

```sql
select
	*
from
	attributes_plus ap
where
	title = 'Crete soil metagenome';
```

probably not indexed on title
141 rows
no bioproject id mentioned, but has ERS ids in sra_id


```sql
select
	*
from
	non_attribute_metadata nam 
where
	title = 'Crete soil metagenome';
```

much faster (but possibly cached?)
saved as ``

```sql
select
	naal.*
from
	non_attribute_metadata nam
join ncbi_attributes_all_long naal 
	on
	nam.raw_id = naal.raw_id
where
	title = 'Crete soil metagenome';
```

saved as `never_clean/non_attribute_metadata_ncbi_attributes_all_long_202408071507.tsv`

```sql
select
	naal.attribute_name ,
	naal.harmonized_name ,
	count(1) as count
from
	non_attribute_metadata nam
join ncbi_attributes_all_long naal 
	on
	nam.raw_id = naal.raw_id
where
	title = 'Crete soil metagenome'
group by
	naal.attribute_name ,
	naal.harmonized_name
order by
	attribute_name ;
```

`never_clean/non_attribute_metadata_ncbi_attributes_all_long_202408071511.tsv`

