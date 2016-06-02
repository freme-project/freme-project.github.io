---
layout: page
title: Simplify FREME output using SPARQL filters
dropdown: Knowledge Base, FREME for API Users
pos: 4.3
---

# Simplify FREME output using SPARQL filters

The FREME e-services provide postprocessing functionality. All retrievable RDF content, like NER output, can be filtered e.g. to get only a list of entities instead of full NIF. This is achieved by executing SPARQL queries against the output of the FREME e-services.

A filter has to be a valid SPARQL query. At the moment, only SELECT queries are permitted.

## Contents

* [Available filters](#available-filters)
* [Using filters](#using-filters)
* [Manage filters](#manage-filters)
* [Filtering by its own](#filtering-by-its-own)

## Available filters

* `extract-entities-only`: extract all objects of triples with "itsrdf:taIdentRef" property
* `terminology-terms-only`
* `sourcelang-targetlang`
* `original-and-translation`
* `entities-detailed-info`
* `place-and-lat-long`
* `museums-nearby`
* `freme-workflow-editor-terminology`

**NOTE:** The list above will be updated from time to time. To see an up to date list of all publicly available SPARQL filters use the API endpoint `GET {{ site.apiurl | prepend: site.url }}/toolbox/convert/manage`, see [this section](#get-all-filters).

## Using filters

A filter with the name `FILTERNAME` can be used by adding the parameter `filter=FILTERNAME` to any enrichment request.

When using filters, the possible outformat/accept-header values differ from standard usage.
In the case of **SELECT** filters the following output formats are allowed (mime type versions for accept header in brackets):

* **csv** (text/comma-separated-values): this is the default value
* **json** (application/json)
* **xml** (text/xml)
* any RDF format accepted by FREME enrichment e-services e.g. turtle (text/turtle)


**Example query:**

```
curl -X POST --header "Content-Type: text/plain" -d "The Eiffel Tower (/ˈaɪfəl ˈtaʊər/ EYE-fəl TOWR; French: tour Eiffel [tuʁ‿ɛfɛl] About this sound listen) is a wrought iron lattice tower on the Champ de Mars in Paris." "{{ site.apiurl | prepend: site.url }}/e-entity/freme-ner/documents?outformat=csv&language=en&dataset=dbpedia&mode=all&filter=extract-entities-only"
```

This query should return all named entities in the first sentence of the [eiffel tower wikipedia article](https://en.wikipedia.org/wiki/Eiffel_Tower) as **CSV table**:

```
entity
http://dbpedia.org/resource/Champ_de_Mars
http://dbpedia.org/resource/Torkham
http://dbpedia.org/resource/Eiffel_Tower
http://dbpedia.org/resource/France
http://dbpedia.org/resource/Paris
http://dbpedia.org/resource/Eiffel_(programming_language)
```
**NOTE**: The first row of the output above contains the table header.


The following output would be the result without using a filter (also remove 'outformat=csv' which is not supported when the filter is not used):

```
@prefix dbpedia-fr: <http://fr.dbpedia.org/resource/> .
@prefix dbc:   <http://dbpedia.org/resource/Category:> .
@prefix dbpedia-es: <http://es.dbpedia.org/resource/> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix dbpedia: <http://dbpedia.org/resource/> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dbpedia-de: <http://de.dbpedia.org/resource/> .
@prefix dbpedia-ru: <http://ru.dbpedia.org/resource/> .
@prefix freme-onto: <http://freme-project.eu/ns#> .
@prefix dbpedia-nl: <http://nl.dbpedia.org/resource/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix dbpedia-it: <http://it.dbpedia.org/resource/> .

<http://freme-project.eu/#char=61,67>
        a                     nif:Phrase , nif:String , nif:RFC5147String , nif:Word ;
        nif:anchorOf          "Eiffel"^^xsd:string ;
        nif:beginIndex        "61"^^xsd:int ;
        nif:endIndex          "67"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,166> ;
        itsrdf:taClassRef     <http://nerd.eurecom.fr/ontology#Person> ;
        itsrdf:taConfidence   "0.7492976009002771"^^xsd:double ;
        itsrdf:taIdentRef     <http://dbpedia.org/resource/Eiffel_(programming_language)> .

<http://freme-project.eu/#char=160,165>
        a                     nif:String , nif:Word , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Paris"^^xsd:string ;
        nif:beginIndex        "160"^^xsd:int ;
        nif:endIndex          "165"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,166> ;
        itsrdf:taClassRef     <http://nerd.eurecom.fr/ontology#Location> ;
        itsrdf:taConfidence   "0.9414122694394742"^^xsd:double ;
        itsrdf:taIdentRef     dbpedia:Paris .

<http://freme-project.eu/#char=48,54>
        a                     nif:Word , nif:RFC5147String , nif:String , nif:Phrase ;
        nif:anchorOf          "French"^^xsd:string ;
        nif:beginIndex        "48"^^xsd:int ;
        nif:endIndex          "54"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,166> ;
        itsrdf:taClassRef     <http://www.w3.org/2002/07/owl#Thing> ;
        itsrdf:taConfidence   "0.9138189959833969"^^xsd:double ;
        itsrdf:taIdentRef     dbpedia:France .

<http://freme-project.eu/#char=34,41>
        a                     nif:RFC5147String , nif:Word , nif:Phrase , nif:String ;
        nif:anchorOf          "EYE-fəl"^^xsd:string ;
        nif:beginIndex        "34"^^xsd:int ;
        nif:endIndex          "41"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,166> ;
        itsrdf:taClassRef     <http://www.w3.org/2002/07/owl#Thing> ;
        itsrdf:taConfidence   "0.5444451198595404"^^xsd:double .

<http://freme-project.eu/#char=0,166>
        a               nif:String , nif:Context , nif:RFC5147String ;
        nif:beginIndex  "0"^^xsd:int ;
        nif:endIndex    "166"^^xsd:int ;
        nif:isString    "The Eiffel Tower (/ˈaɪfəl ˈtaʊər/ EYE-fəl TOWR; French: tour Eiffel [tuʁ‿ɛfɛl] About this sound listen) is a wrought iron lattice tower on the Champ de Mars in Paris."^^xsd:string .

<http://freme-project.eu/#char=4,16>
        a                     nif:String , nif:RFC5147String , nif:Phrase , nif:Word ;
        nif:anchorOf          "Eiffel Tower"^^xsd:string ;
        nif:beginIndex        "4"^^xsd:int ;
        nif:endIndex          "16"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,166> ;
        itsrdf:taClassRef     <http://nerd.eurecom.fr/ontology#Location> ;
        itsrdf:taConfidence   "0.9992749049645933"^^xsd:double ;
        itsrdf:taIdentRef     dbpedia:Eiffel_Tower .

<http://freme-project.eu/#char=143,156>
        a                     nif:RFC5147String , nif:Word , nif:String , nif:Phrase ;
        nif:anchorOf          "Champ de Mars"^^xsd:string ;
        nif:beginIndex        "143"^^xsd:int ;
        nif:endIndex          "156"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,166> ;
        itsrdf:taClassRef     <http://nerd.eurecom.fr/ontology#Location> ;
        itsrdf:taConfidence   "0.8939840501437454"^^xsd:double ;
        itsrdf:taIdentRef     dbpedia:Champ_de_Mars .
```

**NOTE:** The postprocessing works embedded in **pipelines**, too. Just add the filter parameter to the last request:

```
curl -X POST --header "Content-Type: application/json" -d "[ {   \"method\": \"POST\",   \"endpoint\": \"{{ site.apiurl | prepend: site.url }}/e-entity/dbpedia-spotlight/documents\",   \"parameters\": {     \"language\": \"en\"   },   \"headers\": {     \"content-type\": \"text/plain\",     \"accept\": \"text/turtle\"   },   \"body\": \"This summer there is the Zomerbar in Antwerp, one of the most beautiful cities in Belgium.\" }, {   \"method\": \"POST\",   \"endpoint\": \"{{ site.apiurl | prepend: site.url }}/e-link/documents/\",   \"parameters\": {     \"templateid\": \"3\",     \"filter\": \"extract-entities-only\", \"outformat\": \"xml\"   },   \"headers\": {     \"content-type\": \"text/turtle\"   } } ]" "{{ site.apiurl | prepend: site.url }}/pipelining/chain?stats=false"
```

NOTE: The filter parameter can also be added to the surrounding request to the pipelining service:

```
curl -X POST --header "Content-Type: application/json" -d "[ {   \"method\": \"POST\",   \"endpoint\": \"{{ site.apiurl | prepend: site.url }}/e-entity/dbpedia-spotlight/documents\",   \"parameters\": {     \"language\": \"en\"   },   \"headers\": {     \"content-type\": \"text/plain\",     \"accept\": \"text/turtle\"   },   \"body\": \"This summer there is the Zomerbar in Antwerp, one of the most beautiful cities in Belgium.\" }, {   \"method\": \"POST\",   \"endpoint\": \"{{ site.apiurl | prepend: site.url }}/e-link/documents/\",   \"parameters\": {     \"templateid\": \"3\"   },   \"headers\": {     \"content-type\": \"text/turtle\"   } } ]" "{{ site.apiurl | prepend: site.url }}/pipelining/chain?stats=false&filter=extract-entities-only&outformat=xml"
```

The two pipeline requests mentioned above are semantically equal and use `e-entity (FREME-Ner) --> e-link --> filter: extract-entities-only`. They should return the following:

```
<?xml version="1.0"?>
<sparql xmlns="http://www.w3.org/2005/sparql-results#">
  <head>
    <variable name="entity"/>
  </head>
  <results>
    <result>
      <binding name="entity">
        <uri>http://dbpedia.org/resource/Belgium</uri>
      </binding>
    </result>
    <result>
      <binding name="entity">
        <uri>http://dbpedia.org/resource/Beauty</uri>
      </binding>
    </result>
    <result>
      <binding name="entity">
        <uri>http://dbpedia.org/resource/Sathya_Sai_Baba</uri>
      </binding>
    </result>
    <result>
      <binding name="entity">
        <uri>http://dbpedia.org/resource/City</uri>
      </binding>
    </result>
    <result>
      <binding name="entity">
        <uri>http://dbpedia.org/resource/Antwerp</uri>
      </binding>
    </result>
  </results>
</sparql>
```


## Manage filters

Filters can be managed via the REST API endpoint `/toolbox/convert/manage/{filterName}`. Filters are restricted resources, so some requests need authenticated access. See [authentication]({{ site.apiurl | prepend: site.url }}/doc/knowledge-base/freme-for-api-users/authentication.html) for further information. 

**NOTE:** When using the following examples, don't forget to replace `YOUR_TOKEN` by your authentication token.

### Add a filter
```
curl -X POST --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/plain" -d SPARQL_QUERY "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage?name={filterName}"
```

Example:

```
curl -X POST --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/plain" -d "PREFIX itsrdf: <http://www.w3.org/2005/11/its/rdf#> SELECT ?charsequence ?entity WHERE {?charsequence itsrdf:taIdentRef ?entity}" "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage/extract-entities-only"
```

### Get a filter
```
curl -X GET [--header "X-Auth-Token: YOUR_TOKEN"] "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage/{filterName}"
```

Example:

```
curl -X GET "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage/extract-entities-only"
```

### Get all filters

This request returns all filters to which the currently authenticated user has **read access**, see [authentication]({{ site.url }}/doc/knowledge-base/freme-for-api-users/authentication.html) for further information.

```
curl -X GET [--header "X-Auth-Token: YOUR_TOKEN"] "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage"
```

Example:

```
curl -X GET "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage"
```

### Update a filter
```
curl -X PUT --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/plain" -d NEW_SPARQL_QUERY "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage/{filterName}[&newOwner=NEW_OWNER_NAME][&visibility=NEW_VISIBILITY]"
```

Examples:


This changes the filter:

```
curl -X PUT --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/plain" -d "PREFIX itsrdf: <http://www.w3.org/2005/11/its/rdf#> SELECT ?entity WHERE {?charsequence itsrdf:taIdentRef ?entity}" "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage/extract-entities-only"
```

To change the owner and the visibility, you can do this:

```
curl -X PUT --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/plain" "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage/extract-entities-only?newOwner=klaus&visibility=private"
```
NOTE: The User `klaus` has to exist.
NOTE: The two example requests can be merged, it was splitted just for explanation purposes.

### Delete a filter
```
curl -X DELETE --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage/{filterName}"
```

Example:

```
curl -X DELETE --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiurl | prepend: site.url }}/toolbox/convert/manage/extract-entities-only"
```

## Filtering by its own
 
Freme provides the possibility to filter any (NIF) document with the provided filters. Just send your document to the following endpoint:
  
```
POST {{ site.apiurl | prepend: site.url }}/toolbox/convert/documents/{filterName}
```

**NOTE:** Please use the correct `Content-Type` and `Accept` header or `informat` and `outformat` parameter values according to your uploaded and desired file format!

**NOTE:** This service **supports all formats** supported by FREME. Have a look into the [General Information of our api documentation]({{ site.url }}/doc/api-doc/full.html#!General_Information) to have an overview about the supported in- and outformats.

**NOTE:** You can send the input via the post body or as value of the NIF `input` parameter.  

Example:

```
curl -X POST -d @file "{{ site.apiurl | prepend: site.url }}/toolbox/convert/documents/extract-entities-only?informat=turtle&outformat=csv"
```

which results in:

```
entity
http://dbpedia.org/resource/France
http://dbpedia.org/resource/Paris
http://dbpedia.org/resource/Eiffel_(programming_language)
```


if `file` contains the following:

```
@prefix dbpedia-fr: <http://fr.dbpedia.org/resource/> .
@prefix dbc:   <http://dbpedia.org/resource/Category:> .
@prefix dbpedia-es: <http://es.dbpedia.org/resource/> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix dbpedia: <http://dbpedia.org/resource/> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dbpedia-de: <http://de.dbpedia.org/resource/> .
@prefix dbpedia-ru: <http://ru.dbpedia.org/resource/> .
@prefix freme-onto: <http://freme-project.eu/ns#> .
@prefix dbpedia-nl: <http://nl.dbpedia.org/resource/> .
@prefix dcterms: <http://purl.org/dc/terms/> .
@prefix dbpedia-it: <http://it.dbpedia.org/resource/> .

<http://freme-project.eu/#char=61,67>
        a                     nif:Phrase , nif:String , nif:RFC5147String , nif:Word ;
        nif:anchorOf          "Eiffel"^^xsd:string ;
        nif:beginIndex        "61"^^xsd:int ;
        nif:endIndex          "67"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,166> ;
        itsrdf:taClassRef     <http://nerd.eurecom.fr/ontology#Person> ;
        itsrdf:taConfidence   "0.7492976009002771"^^xsd:double ;
        itsrdf:taIdentRef     <http://dbpedia.org/resource/Eiffel_(programming_language)> .

<http://freme-project.eu/#char=160,165>
        a                     nif:String , nif:Word , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Paris"^^xsd:string ;
        nif:beginIndex        "160"^^xsd:int ;
        nif:endIndex          "165"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,166> ;
        itsrdf:taClassRef     <http://nerd.eurecom.fr/ontology#Location> ;
        itsrdf:taConfidence   "0.9414122694394742"^^xsd:double ;
        itsrdf:taIdentRef     dbpedia:Paris .

<http://freme-project.eu/#char=48,54>
        a                     nif:Word , nif:RFC5147String , nif:String , nif:Phrase ;
        nif:anchorOf          "French"^^xsd:string ;
        nif:beginIndex        "48"^^xsd:int ;
        nif:endIndex          "54"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,166> ;
        itsrdf:taClassRef     <http://www.w3.org/2002/07/owl#Thing> ;
        itsrdf:taConfidence   "0.9138189959833969"^^xsd:double ;
        itsrdf:taIdentRef     dbpedia:France .

<http://freme-project.eu/#char=34,41>
        a                     nif:RFC5147String , nif:Word , nif:Phrase , nif:String ;
        nif:anchorOf          "EYE-fəl"^^xsd:string ;
        nif:beginIndex        "34"^^xsd:int ;
        nif:endIndex          "41"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,166> ;
        itsrdf:taClassRef     <http://www.w3.org/2002/07/owl#Thing> ;
        itsrdf:taConfidence   "0.5444451198595404"^^xsd:double .

<http://freme-project.eu/#char=0,166>
        a               nif:String , nif:Context , nif:RFC5147String ;
        nif:beginIndex  "0"^^xsd:int ;
        nif:endIndex    "166"^^xsd:int ;
        nif:isString    "The Eiffel Tower (/ˈaɪfəl ˈtaʊər/ EYE-fəl TOWR; French: tour Eiffel [tuʁ‿ɛfɛl] About this sound listen) is a wrought iron lattice tower on the Champ de Mars in Paris."^^xsd:string .
```


