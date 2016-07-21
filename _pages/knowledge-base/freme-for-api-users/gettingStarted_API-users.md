---
title: "Getting started for API Users"
dropdown: Knowledge Base, FREME for API Users
pos: 4.5
---

This article shall give the API-user an idea how to use the FREME API.

##  How to create an API request

The following URL represents a simple API call which returns all publicly available datasets of FREME-NER:
[http://api-dev.freme-project.eu/current/e-entity/freme-ner/datasets](http://api-dev.freme-project.eu/current/e-entity/freme-ner/datasets).


This call uses the default HTTP method GET. With the Http method POST you can send data to the server which then returns the processed data. A POST request cannot simply be executed by the browser as it is possible with GET. There are several tools that can be used, e.g. [Postman](https://www.getpostman.com/), [Poster](https://addons.mozilla.org/de/firefox/addon/poster/) or [curl](https://curl.haxx.se/).
The endpoints that FREME provides are specified in the [complete API documentation](../api-doc/full.html) where you can also try them out. When you make an API call there the corresponding curl - command will be generated. 

```
curl -X POST --header 'Content-Type: text/plain' --header 'Accept: text/turtle' 'http://api-dev.freme-project.eu/current/e-entity/dbpedia-spotlight/documents?input=Welcome%20to%20Berlin%2C%20the%20capital%20of%20Germany.&numLinks=1&language=en&confidence=0.3'
```

This example call to e-entity/dbpedia-spotlight/documents which spots entities in the data you send via the input parameter. The call specifies two headers, **Content-Type** and **Accept**. The Content-Type header exists for both the request and the response, it refers to the dataformat of the data that was send to or back from the service. The Accept-header specifies which dataformat you want to accept for the response. 


## Input types 

In general, FREME services can be used with plain text data or NIF ([NIF Specification](http://persistence.uni-leipzig.org/nlp2rdf/specification/api.html)) documents depending on the particular service. [E-internationalisation](../freme-for-api-users/eInternationalisation.html) makes it possible to also submit data with different formats, e.g. html.

For an introduction to the NLP interchange Format (NIF) have a look at [these slides](http://de.slideshare.net/m1ci/nif-tutorial).

## Output types

You can use SPARQL filters in order to get only specific output back from the service. [This article](../freme-for-api-users/filtering.html) describes these filters and their application. 




