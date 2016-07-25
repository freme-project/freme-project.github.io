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
[http://api.freme-project.eu/current/e-entity/freme-ner/datasets](http://api.freme-project.eu/current/e-entity/freme-ner/datasets).


This call uses the default HTTP method GET. With the Http method POST you can send data to the server which then returns the processed data. A POST request cannot simply be executed by the browser as it is possible with GET. There are several tools that can be used, e.g. [Postman](https://www.getpostman.com/), [Poster](https://addons.mozilla.org/de/firefox/addon/poster/) or [curl](https://curl.haxx.se/).
The endpoints that FREME provides are specified in the [complete API documentation](../../api-doc/full.html) where you can also try them out. When you make an API call there the corresponding curl - command will be generated.

```
curl -X POST --header 'Content-Type: text/plain' --header 'Accept: text/turtle' 'http://api.freme-project.eu/current/e-entity/dbpedia-spotlight/documents?input=Welcome%20to%20Berlin%2C%20the%20capital%20of%20Germany.&numLinks=1&language=en&confidence=0.3'
```

This example call to e-entity/dbpedia-spotlight/documents which spots entities in the data you send via the input parameter. The call specifies two headers, **Content-Type** and **Accept**. The Content-Type header exists for both the request and the response, it refers to the dataformat of the data that was send to or back from the service. The Accept-header specifies which dataformat you want to accept for the response. 
These headers are not mandatory, but it is highly recommended to set them. The tools, e.g. Postman, or browsers may set them implicitly if they are not specified which can result in unexpected behaviour.

<html>
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
<col width="38%"></col>
<col width="26%"></col>
<col width="36%"></col>
<col width="11%"></col>
</colgroup>
<thead>
<tr class="header">
<th align="left"></th>
<th align="left">Input Format</th>
<th align="left">Content-Type header</th>
<th align="left">remarks</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><strong>NIF</strong></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">standard</td>
</tr>
<tr class="even">
<td align="left"></td>
<td align="left">turtle</td>
<td align="left">text/turtle</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"></td>
<td align="left">rdf-xml</td>
<td align="left">text/rdf-xml</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><strong>Plaintext</strong></td>
<td align="left">plain</td>
<td align="left">text/plain</td>
<td align="left">standard</td>
</tr>
<tr class="odd">
<td align="left"><strong>e-internationalization</strong></td>
<td align="left"></td>
<td align="left"></td>
<td align="left" rowspan="5">Makes it possible to uplaod files with different format than NIF. A full description of all formats can be found in the <a href="../freme-for-api-users/eInternationalisation.html">e-internationalization article</a>.</td>
</tr>
<tr class="even">
<td align="left"></td>
<td align="left">xliff 1.2</td>
<td align="left">application/x-xliff+xml</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"></td>
<td align="left">ODT</td>
<td align="left">application/x-openoffice</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"></td>
<td align="left">xml</td>
<td align="left">text/xml</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"></td>
<td align="left">html</td>
<td align="left">text/html</td>
<td align="left"></td>
</tr>
</tbody>
</table>
</div>
<div id="output-types" class="section level1">
<h2>Output Types</h2>
<table style="width:178%;">
<colgroup>
<col width="38%"></col>
<col width="33%"></col>
<col width="40%"></col>
<col width="65%"></col>
</colgroup>
<thead>
<tr class="header">
<th align="left"></th>
<th align="left">Input Format</th>
<th align="left">Accept header</th>
<th align="left">remarks</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left"><strong>NIF</strong></td>
<td align="left"></td>
<td align="left"></td>
<td align="left">standard</td>
</tr>
<tr class="even">
<td align="left"></td>
<td align="left">turtle</td>
<td align="left">text/turtle</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"></td>
<td align="left">rdf-xml</td>
<td align="left">text/rdf-xml</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"><strong>e-internationalization</strong></td>
<td align="left"></td>
<td align="left"></td>
<td align="left" rowspan="5">For the e-internationalization formats the output type must be the same as the input type.</td>
</tr>
<tr class="odd">
<td align="left"></td>
<td align="left">xliff 1.2</td>
<td align="left">application/x-xliff+xml</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"></td>
<td align="left">ODT</td>
<td align="left">application/x-openoffice</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"></td>
<td align="left">xml</td>
<td align="left">text/xml</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"></td>
<td align="left">html</td>
<td align="left">text/html</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"><strong>SPARQL-converter outputs</strong></td>
<td align="left">csv</td>
<td align="left">text/comma-seperated-values</td>
<td align="left">default SPARQL format</td>
</tr>
<tr class="even">
<td align="left"></td>
<td align="left">json</td>
<td align="left">application/json</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left"></td>
<td align="left">xml</td>
<td align="left">text/xml</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left"></td>
<td align="left">any <em>RDF</em> format</td>
<td align="left"></td>
<td align="left" rowspan="2">Must be accepted by FREMEenrichments services.</td>
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
</html>

## Natural Language Interchange Format (NIF)

The Natural Language Processing interchange format (NIF) is the default output format of all FREME e-Services. This is an RDF based data format that can be serialized in different formats such as turtle, rdf-xml and others. When you create a pipeline then internally the pipeline should speak NIF to make sure that all pipeline steps are compatible to each other. You can either parse the output of FREME directly using a suitable
RDF library our you can use the [Postprocessing Filters](../freme-for-api-users/filtering.html) to get a more traditional output format. You can find more information about NIF in [these slides](http://de.slideshare.net/m1ci/nif-tutorial) or the [official NIF reference](http://persistence.uni-leipzig.org/nlp2rdf/specification/api.html).
