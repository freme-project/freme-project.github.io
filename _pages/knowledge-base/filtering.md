---
layout: page
title: Postprocessing with SPARQL filters
dropdown: Knowledge Base
pos: 4.8
---

# Postprocessing with SPARQL filters

The FREME e-services provide postprocessing functionality. 
All retrievable RDF content, like NER output, can be filtered 
e.g. to get only a list of entities instead of full NIF. 
This is achieved by executing SPARQL queries against the output of
the FREME e-services.

## Managing filters

Filters can be managed via the REST API endpoint `/toolbox/filter/manage/{filterName}`. 
Filters are restricted resources, so some requests need authenticated access. 
See [authentication]({{ site.url }}/doc/knowledge-base/authentication.md) for further information. 

A filter has to be a valid SPARQL query. At the moment, only SELECT queries are permitted.

### Add a filter
```
curl -X POST -d FILTER "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage/{filterName}"
```

Example:

```
curl -X POST -d "PREFIX itsrdf: <http://www.w3.org/2005/131/its/rdf#>\nSELECT ?s ?o\nWHERE {?s itsrdf:taIdentRef ?o}" "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage/extract-entities-only"
```

### Get a filter
```
curl -X GET "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage/{filterName}"
```

Example:

```
curl -X GET "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage/extract-entities-only"
```

### Get all filters

This returns all filters to which the currently authenticated user has read access, see [authentication]({{ site.url }}/doc/knowledge-base/authentication.html) for further information.

```
curl -X GET "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage"
```

Example:

```
curl -X GET "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage"
```

### Update a filter
```
curl -X PUT -d NEWFILTER "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage/{filterName}"
```

Examples:

This changes the filter:

```
curl -X PUT -d "PREFIX itsrdf: <http://www.w3.org/2005/131/its/rdf#>\nSELECT ?o\nWHERE {?s itsrdf:taIdentRef ?o}" "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage/extract-entities-only"
```

To change the owner and the visibility, you can do this:

```
curl -X PUT "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage/extract-entities-only?newOwner=klaus&visibility=private"
```
NOTE: The User `klaus` has to exist.
NOTE: The two example requests can be merged, it was splitted just for explanation purposes.

### Delete a filter
```
curl -X DELETE "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage/{filterName}"
```

Example:

```
curl -X DELETE "{{ site.apiurl | prepend: site.url }}/toolbox/filter/manage/extract-entities-only"
```

## Using filters


