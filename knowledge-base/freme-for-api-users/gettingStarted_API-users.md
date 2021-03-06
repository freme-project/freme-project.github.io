---
layout: page
title: Getting started for API Users
dropdown: Knowledge Base, FREME for API Users
pos: 4.5
---

# Getting started for API Users

This article shall give the API-user an idea how to use the FREME API.

##  How to create an API request

The following URL represents a simple API call which returns all publicly available datasets of FREME-NER:
[{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol }}/e-entity/freme-ner/datasets]({{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol }}/e-entity/freme-ner/datasets).


This call uses the default HTTP method GET. With the Http method POST you can send data to the server which then returns the processed data. A POST request cannot simply be executed by the browser as it is possible with GET. There are several tools that can be used, e.g. [Postman](https://www.getpostman.com/), [Poster](https://addons.mozilla.org/de/firefox/addon/poster/) or [curl](https://curl.haxx.se/).
The endpoints that FREME provides are specified in the [complete API documentation](../../api-doc/full.html) where you can also try them out. When you make an API call there the corresponding curl - command will be generated.

```
curl -X POST --header 'Content-Type: text/plain' --header 'Accept: text/turtle' '{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol }}/e-entity/dbpedia-spotlight/documents?input=Welcome%20to%20Berlin%2C%20the%20capital%20of%20Germany.&numLinks=1&language=en&confidence=0.3'
```

This example call to e-entity/dbpedia-spotlight/documents which spots entities in the data you send via the input parameter. The call specifies two headers, **Content-Type** and **Accept**. The Content-Type header exists for both the request and the response, it refers to the dataformat of the data that was send to or back from the service. The Accept-header specifies which dataformat you want to accept for the response. 
These headers are not mandatory, but it is highly recommended to set them. The tools, e.g. Postman, or browsers may set them implicitly if they are not specified which can result in unexpected behaviour.

<div class="container-fluid main-container">

<style type="text/css">
.main-container {
  max-width: 940px;
  margin-left: auto;
  margin-right: auto;
}
code {
  color: inherit;
  background-color: rgba(0, 0, 0, 0.04);
}
img {
  max-width:100%;
  height: auto;
}
.tabbed-pane {
  padding-top: 12px;
}
button.code-folding-btn:focus {
  outline: none;
}
</style>

<div class="fluid-row" id="header">
</div>

<div id="input-types" class="section level1">
<h2>Input Types</h2>
<table style="width:112%;" align="left">
<colgroup>
    <col width="38%"/>
    <col width="26%"/>
    <col width="36%"/>
    <col width="11%"/>
</colgroup>
<thead>
<tr class="header">
    <th align="left"></th>
    <th align="left">Format</th>
    <th align="left">Content-Type header</th>
    <th align="left">remarks</th>
</tr>
</thead>
<tbody>
<tr class="even">
<td align="left" rowspan="5"><strong>NIF</strong></td>
<td align="left">turtle</td>
<td align="left">text/turtle</td>
<td align="left">default</td>
</tr>
<tr class="odd">
<td align="left">rdf-xml</td>
<td align="left">text/rdf-xml</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left">json</td>
<td align="left">application/ld+json</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left">N-Triples</td>
<td align="left">application/n-triples</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left">N3</td>
<td align="left">text/n3</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><strong>Plaintext</strong></td>
<td align="left">plain</td>
<td align="left">text/plain</td>
<td align="left">standard</td>
</tr>
<tr class="even">
<td align="left" rowspan="4"><a href="../freme-for-api-users/eInternationalisation.html"><strong>e-internationalization</strong></a></td>
<td align="left">xliff 1.2</td>
<td align="left">application/x-xliff+xml</td>
 <td align="left" rowspan="4">Makes it possible to upload files with different format than NIF. </td>
</tr>
<tr class="odd">
<td align="left">ODT</td>
<td align="left">application/x-openoffice</td>
</tr>
<tr class="even">
<td align="left">xml</td>
<td align="left">text/xml</td>
</tr>
<tr class="odd">
<td align="left">html</td>
<td align="left">text/html</td>
</tr>
<tr class="even">
<td align="left" rowspan="3"><a href="../freme-for-api-users/xslt-transformation.html"><strong>XSLT Converter</strong></a></td>
<td align="left">xml</td>
<td align="left">text/xml</td>
 <td align="left" rowspan="3">Use XSLT-converter to transform xml and html files with xslt stylesheets.</td>
</tr>
<tr class="odd">
<td align="left">html</td>
<td align="left">text/html</td>
</tr>
</tbody>
</table>


</div>
<div id="output-types" class="section level1">
<h2>Output Types</h2>
<table style="width:178%;">
<colgroup>
<col width="38%"/>
<col width="33%"/>
<col width="40%"/>
<col width="65%"/>
</colgroup>
<thead>
<tr class="header">
<th align="left"></th>
<th align="left">Format</th>
<th align="left">Accept header</th>
<th align="left">remarks</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left" rowspan="5"><strong>NIF</strong></td>
<td align="left">turtle</td>
<td align="left">text/turtle</td>
<td align="left">default</td>
</tr>
<tr class="even">
<td align="left">rdf-xml</td>
<td align="left">text/rdf-xml</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left">json</td>
<td align="left">application/ld+json</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left">N-Triples</td>
<td align="left">application/n-triples</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left">N3</td>
<td align="left">text/n3</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left" rowspan="4" id="output-types-einternalisation"><a href="../freme-for-api-users/eInternationalisation.html"><strong>e-internationalization</strong></a></td>
<td align="left">xliff 1.2</td>
<td align="left">application/x-xliff+xml</td>
<td align="left" rowspan="4">For the e-internationalization formats the output type must be the same as the input type.</td>
</tr>
<tr class="even">
<td align="left">ODT</td>
<td align="left">application/x-openoffice</td>
</tr>
<tr class="odd">
<td align="left">xml</td>
<td align="left">text/xml</td>
</tr>
<tr class="even">
<td align="left">html</td>
<td align="left">text/html</td>
</tr>
<tr class="odd">
<td align="left" rowspan="4" ><strong><a href="../freme-for-api-users/filtering.html">SPARQL-converter</a> outputs</strong></td>
<td align="left">csv</td>
<td align="left">text/comma-seperated-values</td>
<td align="left">default</td>
</tr>
<tr class="even">
<td align="left">json</td>
<td align="left">application/json</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left">xml</td>
<td align="left">text/xml</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><em>RDF</em> formats</td>
<td align="left"></td>
<td align="left" >Must be accepted by FREME enrichment services.</td>
</tr>
  <tr class="even">
<td align="left" rowspan="3"><a href="../freme-for-api-users/xslt-transformation.html"><strong>XSLT Converter</strong></a></td>
<td align="left">xml</td>
<td align="left">text/xml</td>
 <td align="left" rowspan="3">Use XSLT-converter to transform xml and html files with xslt stylesheets.</td>
</tr>
<tr class="odd">
<td align="left">html</td>
<td align="left">text/html</td>
</tr>
</tbody>
</table>
</div>




</div>

<script>
// add bootstrap table styles to pandoc tables
$(document).ready(function () {
  $('tr.header').parent('thead').parent('table').addClass('table table-condensed');
});
</script>

## Retrieve input from an URL
When you want to process text from an url, you can set the parameter **intype** to *url* and specify the url in the **input** (or its short version **i**) - parameter. If you do not send a Content-Type Header nor specify the informat parameter, the default Content-Type **text/turtle** is used. 
Below you can see an example call to FREME-NER where the text to be processed is retrieved from an URL.

```
curl -X POST '{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol }}/e-entity/freme-ner/documents?language=en&dataset=dbpedia&mode=all&intype=url&input=http://beautifulberlin.blogspot.de/2009/07/short-history-of-berlin.html&filter=extract-entities-only&outformat=csv&informat=text/html'
```

## Use Apache Tika to process content from files
You can also process text from a file of a [format](https://tika.apache.org/1.4/formats.html) that is supported by Tika.
In this case, you have to specify the following two additional parameters in your request:

* filename=THE_NAME_OF_YOUR_FILE
* informat=TIKAFile



## FREME Postman collection

[Postman](https://www.getpostman.com/) is a handy and free tool to execute and archive your commonly used HTTP requests. We publish a collection of pre-build FREME API calls that can be executed against the FREME Demo APIs or against your own local FREME installations. These collections can also be used to generate API calls in programming languages such as Java, PHP, jQuery and others.

How to use the collection: Import [this Postman collection]({{site.basePath  }}/resources/postman/FREME.postman_collection.json) into your local Postman to have a set of working requests which covers the most of FREME functionality out of the box. To get this collection working just define the [Postman variable](https://www.getpostman.com/docs/environments) `baseUrl` and set it to `api.freme-project.eu/current`, for instance. Furthermore, if you intend to create or modify [restricted resources](../freme-for-api-users/authentication.html#restricted-resources) like [FREME templates]({{site.basePath  }}/api-doc/list-templates.html), [filters](../freme-for-api-users/filtering.html), etc. you have to define and set the variable `token` to the one you get when you have [authenticated](../freme-for-api-users/authentication.html#how-to-authenticate) successfully. 

## Natural Language Interchange Format (NIF)

The Natural Language Processing interchange format (NIF) is the default output format of all FREME e-Services. This is an RDF based data format that can be serialized in different formats such as turtle, rdf-xml and others. When you create a pipeline then internally the pipeline should speak NIF to make sure that all pipeline steps are compatible to each other. You can either parse the output of FREME directly using a suitable
RDF library our you can use the [Postprocessing Filters](../freme-for-api-users/filtering.html) to get a more traditional output format. You can find more information about NIF in [these slides](http://de.slideshare.net/m1ci/nif-tutorial) or the [official NIF reference](http://persistence.uni-leipzig.org/nlp2rdf/specification/api.html).
