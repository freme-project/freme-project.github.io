---
layout: page
title: e-Internationalisation
dropdown: Knowledge Base, FREME for API Users
pos: 4.2
---

# e-Internationalisation

FREME e-Services work with either plain text or NIF files. The e-Internationalisation let users enrich HTML, XML, XLIFF and ODT files as well. It is not an individual service, but it is indirectly used via other services. The e-Services supporting the e-Internationalisation are 

  * e-Entity
  * e-Link
  * e-Terminology
  * e-Translation
	
With this new functionality a user can invoke one of the supported FREME e-Services, let's say e-Entity, and submit an HTML file. The control goes to the e-Internationalisation first that converts the HTML file to NIF. Finally this NIF file is submitted to e-Entity service. The conversion to NIF is done internally and it's transparent to the user. 

The e-Internationalisation service provides methods for converting following formats to NIF:

  * HTML – MIME-type: text/html
  *	XML – MIME-type: text/xml
  *	XLIFF 1.2 – MIME-type: application/x-xliff+xml
  *	ODT – MIME-type: application/x-openoffice

If the original document contains ITS 2.0 properties, they are translated to proper NIF properties from the itsrdf domain (see [Supported ITS categories](#supported-its-categories) section). `itsrdf` is a commonly used technical prefix in RDF for namespace [http://www.w3.org/2005/11/its/rdf](https://www.w3.org/2005/11/its/rdf-content/its-rdf.html) describing ITS 2.0 / RDF Ontology.
  
**Note:** For the time being the converter assumes that all text is English and adds language tags to the produced NIF. This is not a problem because currently the FREME services do not consider language tags, they just make use of the language submitted via HTTP parameters.

**Note:** If you intend to suppress e-Internalization functionality, it is possible to attach the query parameter `useI18n=false` to any request. Furthermore, you can switch on e-Internalization with `useI18n=true` for blacklisted endpoints, see the parameter `freme.einternationalization.endpoint-blacklist` at [FREME Configuration Options](../freme-for-sysadmins/configuration-options.html#freme.einternationalization.endpoint-blacklist). If `useI18n=undefined` (default) or `useI18n` is not submitted at all, e-Internalization behaves like described in this article for endpoints which are not blacklisted and is disabled for blacklisted ones.  
  
Beside the conversion to NIF, the e-Internationalisation service also provides a method for converting the enriched NIF back to the original file format. We call this functionality `round-tripping` and at the moment it is only available with the HTML or XML format. For example, the user can invoke the e-Entity service by submitting an HTML file and specifying "outformat=html". The HTML file is converted to NIF and then the latter is sent to the e-Entity service. Once the NIF has been enriched, it is converted back to the HTML format. The final HTML file contains enrichments retrieved by the e-Entity service. As for the simple conversion, the process is completely transparent to the user: s/he doesn't have to explicitly call the e-Internationalisation service. Note that only entity and terminology enrichments can be included in the original file format. Although user is allowed to specify HTML or XML output format even for e-Link and e-Translation services, s/he should be aware that the returned HTML/XML file won't contain enrichments retrieved by those services.

So with the introduction of the e-Internationalisation service, new input and output formats are supported when invoking FREME e-Services. 

New input and output formats are `text/html`, `text/xml`, `application/x-xliff+xml` and `application/x-openoffice`.

New output formats are `text/html` and `text/xml`. Note that this output format can be only used when the starting document is an HTML or XML file as well. This is a general rule when performing the round-tripping: input and output formats must be the same. 

## Supported ITS categories

The e-Internationalisation service supports almost all [ITS 2.0 categories](http://www.w3.org/TR/2013/PR-its20-20130924/#datacategory-description)

Below the list of **not** supported ITS 2.0 categories for each file format

* Translate for XLIFF files
* Translate, Locale Filter, MT Confidence and Domain for HTML
* ITS properties support for XML files is still draft. Some categories could not be translated. At the moment a list of unsupported properties is not available.

For the sake of completeness, below are the lists of supported ITS 2.0 categories for each format.

**XLIFF**

* Localization Note
* Terminology
* Text Analysis
* Locale Filter
* Provenance
* Localization Quality Issue
* Localization Quality Rating
* MT Confidence
* Allowed Characters
* Storage Size
* Domain

**HTML**

* Localization Note
* Terminology
* Text Analysis
* Provenance
* Localization Quality Issue
* Localization Quality Rating
* Allowed Characters
* Storage Size

**XML**
Not available.

## Round-tripping: how does it work?

The round-tripping functionality lets users to enrich files having specific formats with entities and terms retrieved by FREME e-services. It is restricted to write named entity annotations and named entity links into the output document.
At the moment the round-tripping is only available for english HTML and XML documents. Users must specify `text/html` or `text/xml` as both input and output formats. Note that requested input and output formats must be the same when performing round-tripping.

This section explains how the e-Internationalisation service implements this functionality.

In HTML/XML to NIF conversion two temporary NIF files are created. The first is a NIF file containing just the plain text of the HTML/XML. The second file contains a context that also includes markups. Let’s call the latter “skeleton”. The skeleton file is locally saved while the first NIF file (without markups) is submitted to enriching FREME e-services. Then the enriched NIF file and the skeleton file are submitted to the e-Internationalisation service which returns the original HTML/XML document with the addition of enrichment annotations.

### Roundtripping example

an HTML file is converted to NIF and enriched with the e-Entity service. Finally it is converted back to the original format. 

Original HTML file

```
<html>
<head>
	<title>Roundtripping</title>
</head>
<body>
<p>Welcome to Dublin</p>
</body>
</html>
```

Converted NIF file

```
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

<http://freme-project.eu/#char=0,31>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "31"^^xsd:nonNegativeInteger ;
        nif:isString    "Roundtripping Welcome to Dublin"@en .

<http://freme-project.eu/#char=14,31>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "Welcome to Dublin"@en ;
        nif:beginIndex        "14"^^xsd:nonNegativeInteger ;
        nif:endIndex          "31"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,31> ;
        dc:identifier         "2" .

<http://freme-project.eu/#char=0,13>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "Roundtripping"@en ;
        nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
        nif:endIndex          "13"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,31> ;
        dc:identifier         "1" .
```

Skeleton NIF file

```
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

<http://freme-project.eu/doc1/#char=0,121>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "121"^^xsd:nonNegativeInteger ;
        nif:isString    "<!DOCTYPE html>\r\n<html><head>\r\n\t<title>Roundtripping</title>\r\n</head>\r\n<body>\r\n<p>Welcome to Dublin</p>\r\n\r\n</body></html>"@en .

<http://freme-project.eu/#char=14,31>
        a                     nif:RFC5147String , nif:String ;
        nif:anchorOf          "Welcome to Dublin"@en ;
        nif:beginIndex        "14"^^xsd:nonNegativeInteger ;
        nif:endIndex          "31"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,31> ;
        nif:wasConvertedFrom  <http://freme-project.eu/doc1/#char=82,99> ;
        dc:identifier         "2" .

<http://freme-project.eu/#char=0,13>
        a                     nif:RFC5147String , nif:String ;
        nif:anchorOf          "Roundtripping"@en ;
        nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
        nif:endIndex          "13"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,31> ;
        nif:wasConvertedFrom  <http://freme-project.eu/doc1/#char=39,52> ;
        dc:identifier         "1" .

<http://freme-project.eu/#char=0,31>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "31"^^xsd:nonNegativeInteger ;
        nif:isString    "Roundtripping Welcome to Dublin"@en .
```

Enriched NIF file

```
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

<http://freme-project.eu/#char=0,31>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "31"^^xsd:nonNegativeInteger ;
        nif:isString    "Roundtripping Welcome to Dublin"@en .

<http://freme-project.eu/#char=14,31>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:referenceContext  <http://freme-project.eu/#char=0,31> ;
        nif:anchorOf          "Welcome to Dublin"@en ;
        nif:beginIndex        "14"^^xsd:nonNegativeInteger ;
        nif:endIndex          "31"^^xsd:nonNegativeInteger ;
        dc:identifier         "2" .

<http://freme-project.eu/#char=0,13>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:referenceContext  <http://freme-project.eu/#char=0,31> ;
        nif:anchorOf          "Roundtripping"@en ;
        nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
        nif:endIndex          "13"^^xsd:nonNegativeInteger ;
        dc:identifier         "1" .
		
<http://freme-project.eu/#char=25,31>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:referenceContext  <http://freme-project.eu/#char=0,31> ;
        nif:anchorOf          "Dublin"@en ;
        nif:beginIndex        "25"^^xsd:nonNegativeInteger ;
        nif:endIndex          "31"^^xsd:nonNegativeInteger ;
        itsrdf:taIdentRef <http://http://dbpedia.org/resource/Dublin> .
```

Original enriched HTML file. Note that some new lines get lost. Anyway it is not relevant because new lines don’t affect the HTML file appearance in the browser.

```
<!DOCTYPE html>
<html><head>
	<title>Roundtripping</title>
</head>
<body>
<p>Welcome to <span its-ta-ident-ref="http://http://dbpedia.org/resource/Dublin">Dublin</span></p>

</body></html>
```

## Entity recognition over HTML
This example shows how to invoke the e-Entity service over a HTML file.

HTML File

```
<!DOCTYPE html>
<html lang="en" >
  <head>
    <meta charset="utf-8" />
  </head>      
  <body>
    <p>Dublin is the capital of Ireland!</p>
  </body>
</html>
```

### Turtle format output
curl HTTP Request

```
curl -X POST -d @docTest.html "http://api.freme-project.eu/current/e-entity/freme-ner/documents?language=en&dataset=dbpedia&mode=all&outformat=turtle"  -H "Content-Type:text/html"
```

Enriched NIF file

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

<http://freme-project.eu/#char=0,33>
        a               nif:Context , nif:RFC5147String , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger , "0"^^xsd:int ;
        nif:endIndex    "33"^^xsd:nonNegativeInteger , "33"^^xsd:int ;
        nif:isString    "Dublin is the capital of Ireland!"@en , "Dublin is the capital of Ireland!"^^xsd:string ;
        <http://purl.org/dc/elements/1.1/identifier>
                "1" .

<http://freme-project.eu/#char=25,32>
        a                     nif:RFC5147String , nif:Phrase , nif:Word , nif:String ;
        nif:anchorOf          "Ireland"^^xsd:string ;
        nif:beginIndex        "25"^^xsd:int ;
        nif:endIndex          "32"^^xsd:int ;
        nif:referenceContext  <http://freme-project.eu/#char=0,33> ;
        itsrdf:taClassRef     <http://nerd.eurecom.fr/ontology#Location> ;
        itsrdf:taConfidence   "0.9450589604243311"^^xsd:double ;
        itsrdf:taIdentRef     dbpedia:Ireland .

```

### Simplified output
This example explains how to spot entities over a HTML document and obtain a simplified output by using [SPARQL filters](filtering.html).

curl HTTP Request

```
curl -X POST -d @docTest.html "http://api.freme-project.eu/current/e-entity/freme-ner/documents?language=en&dataset=dbpedia&mode=all&outformat=csv&filter=extract-entities-only"  -H "Content-Type:text/html"
```

Entities

```
entity
http://dbpedia.org/resource/Ireland
http://dbpedia.org/resource/Dublin
```

### Entity recognition with round-tripping

curl HTTP Request

```
curl -X POST -d @docTest.html "http://api.freme-project.eu/current/e-entity/freme-ner/documents?language=en&dataset=dbpedia&mode=all&outformat=text/html"  -H "Content-Type:text/html"
```

Enriched HTML file

```
<!DOCTYPE html>
<html lang="en"><head>    <meta charset="UTF-8">  </head>        <body>    <p>Dublin is the capital of <span its-ta-ident-ref="http://dbpedia.org/resource/Ireland" its-ta-class-ref="http://nerd.eurecom.fr/ontology#Location" its-ta-confidence="0.9450589604243311">Ireland</span>!</p>  </body></html>
```

## Enrichment of HTML with e-Link

This example shows how to invoke the e-Link service over a HTML file.

HTML file containing an entity

```
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">  
	</head>
	<body>
		<p>Dublin is the capital of <span its-ta-ident-ref="http://dbpedia.org/resource/Ireland" its-ta-class-ref="http://nerd.eurecom.fr/ontology#Location" its-ta-confidence="0.9450589604243311">Ireland</span>!</p>  
	</body>
</html>
```

curl HTTP request

```
curl -X POST -d @docTestWithEntity.html --header "Content-Type: text/html" "http://api.freme-project.eu/current/e-link/documents/?outformat=turtle&templateid=3"
```

Enriched NIF file

```
@prefix dc:    <http://purl.org/dc/elements/1.1/> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .

<http://freme-project.eu/#char=0,33>
        a               nif:Context , nif:RFC5147String , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "33"^^xsd:nonNegativeInteger ;
        nif:isString    "Dublin is the capital of Ireland!"@en ;
        dc:identifier   "1" .

<http://dbpedia.org/resource/Ireland>
        <http://www.w3.org/2003/01/geo/wgs84_pos#lat>
                "53.344166666666666"^^xsd:float , "53.0" , "53.333333333333336"^^xsd:float , "53.0"^^xsd:double , "53" ;
        <http://www.w3.org/2003/01/geo/wgs84_pos#long>
                "-8.0"^^xsd:float , "-8.0" , "-8.0"^^xsd:double , "-8" , "-6.2675"^^xsd:float .

<http://freme-project.eu/#char=25,32>
        a                     nif:RFC5147String , nif:Phrase , nif:String ;
        nif:anchorOf          "Ireland"@en ;
        nif:beginIndex        "25"^^xsd:nonNegativeInteger ;
        nif:endIndex          "32"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,33> ;
        itsrdf:taClassRef     <http://nerd.eurecom.fr/ontology#Location> ;
        itsrdf:taConfidence   "0.9450589604243311"^^xsd:double ;
        itsrdf:taIdentRef     <http://dbpedia.org/resource/Ireland> .
```

### Enrichment of HTML with e-Link and round-tripping

Link enrichments are not reported in the original HTML. The user is still allowed to specify `text/html` as output format, but no information about the links are contained in the final HTML file.


## Terms extraction in HTML

This example shows how to invoke the e-Terminology service over a HTML file.

HTML file 

```
<!DOCTYPE html>
<html lang="en" >
  <head>
    <meta charset="utf-8" />
  </head>      
  <body>
    <p>Dublin is the capital of Ireland!</p>
  </body>
</html>
```

### Turtle format output

curl HTTP Request

```
curl -X POST -d @docTest.html --header "Content-Type: text/html"  "{{ site.apiurl | prepend: site.url }}/e-terminology/tilde?outformat=turtle&source-lang=en&target-lang=it&mode=full"
```

Enriched NIF file

```
@prefix cc:    <http://creativecommons.org/ns#> .
@prefix :      <https://term.tilde.com/terms/> .
@prefix void:  <http://rdfs.org/ns/void#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix its:   <http://www.w3.org/2005/11/its> .
@prefix skos:  <http://www.w3.org/2004/02/skos/core#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix tbx:   <http://tbx2rdf.lider-project.eu/tbx#> .
@prefix decomp: <http://www.w3.org/ns/lemon/decomp#> .
@prefix dct:   <http://purl.org/dc/terms/> .
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix ontolex: <http://www.w3.org/ns/lemon/ontolex#> .
@prefix ldr:   <http://purl.oclc.org/NET/ldr/ns#> .
@prefix odrl:  <http://www.w3.org/ns/odrl/2/> .
@prefix dcat:  <http://www.w3.org/ns/dcat#> .
@prefix prov:  <http://www.w3.org/ns/prov#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

:615455  a                  skos:Concept ;
        rdfs:comment        "Europe and the former Soviet Union"@en , "information and information processing"@en , "political geography"@en , "econom
ic geography"@en ;
        tbx:relatedConcept  "regions of Ireland"@en ;
        tbx:subjectField    <https://term.tilde.com/domains/3231> , <https://term.tilde.com/domains/TaaS-2105> , <https://term.tilde.com/domains/7206>
 , <https://term.tilde.com/domains/7231> , <https://term.tilde.com/domains/TaaS-2000> , <https://term.tilde.com/domains/7236> .

<https://term.tilde.com/terms/Irlanda-it#Sense>
        ontolex:reference  :615455 .

:2745688  a               skos:Concept ;
        tbx:subjectField  <https://term.tilde.com/domains/TaaS-0303> , <https://term.tilde.com/domains/TaaS-0200> , <https://term.tilde.com/domains/40
26> , <https://term.tilde.com/domains/2416004> , <https://term.tilde.com/domains/12> .

:it     a                 ontolex:Lexicon ;
        ontolex:entry     :capitale-it , :Irlanda-it ;
        ontolex:language  <http://www.lexvo.org/page/iso639-3/ita> .

<https://term.tilde.com/terms/capital-en#Sense>
        ontolex:reference  :2745688 , :1217415 .

<https://term.tilde.com/terms/Ireland-en#CanonicalForm>
        ontolex:writtenRep  "Ireland"@en .

<http://freme-project.eu/#char=14,21>
        a                     nif:RFC5147String ;
        nif:anchorOf          "capital"@en ;
        nif:annotationUnit    [ rdfs:label           "capital"@en ;
                                itsrdf:taConfidence  0
                              ] ;
        nif:beginIndex        "14"^^xsd:nonNegativeInteger ;
        nif:endIndex          "21"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,33> ;
        itsrdf:term           "yes" ;
        itsrdf:termInfoRef    :1217415 , <http://aims.fao.org/aos/agrovoc/c_1271> , :2745688 .

:Irlanda-it  a                 ontolex:LexicalEntry ;
        ontolex:canonicalForm  <https://term.tilde.com/terms/Irlanda-it#CanonicalForm> ;
        ontolex:language       <http://www.lexvo.org/page/iso639-3/ita> ;
        ontolex:sense          <https://term.tilde.com/terms/Irlanda-it#Sense> .

<http://freme-project.eu/#char=0,33>
        a               nif:String , nif:RFC5147String , nif:Context ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "33"^^xsd:nonNegativeInteger ;
        nif:isString    "Dublin is the capital of Ireland!"@en ;
        dc:identifier   "1" .

<https://term.tilde.com/terms/Ireland-en#Sense>
        ontolex:reference  :615455 .

:en     a                 ontolex:Lexicon ;
        ontolex:entry     :capital-en , :Ireland-en ;
        ontolex:language  <http://www.lexvo.org/page/iso639-3/eng> .

:Ireland-en  a                 ontolex:LexicalEntry ;
        ontolex:canonicalForm  <https://term.tilde.com/terms/Ireland-en#CanonicalForm> ;
        ontolex:language       <http://www.lexvo.org/page/iso639-3/eng> ;
        ontolex:sense          <https://term.tilde.com/terms/Ireland-en#Sense> .

<http://freme-project.eu/#char=25,32>
        a                     nif:RFC5147String ;
        nif:anchorOf          "Ireland"@en ;
        nif:annotationUnit    [ rdfs:label           "Ireland"@en ;
                                itsrdf:taConfidence  1
                              ] ;
        nif:beginIndex        "25"^^xsd:nonNegativeInteger ;
        nif:endIndex          "32"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,33> ;
        itsrdf:term           "yes" ;
        itsrdf:termInfoRef    :615455 , <http://aims.fao.org/aos/agrovoc/c_3948> .

:capitale-it  a                ontolex:LexicalEntry ;
        tbx:reliabilityCode    3 ;
        ontolex:canonicalForm  <https://term.tilde.com/terms/capitale-it#CanonicalForm> ;
        ontolex:language       <http://www.lexvo.org/page/iso639-3/ita> ;
        ontolex:sense          <https://term.tilde.com/terms/capitale-it#Sense> .

:1217415  a               skos:Concept ;
        rdfs:comment      "information technology and data processing"@en ;
        tbx:subjectField  <https://term.tilde.com/domains/TaaS-1501> , <https://term.tilde.com/domains/3236> .

:       a                 dcat:Dataset , tbx:MartifHeader ;
        dc:source         "" ;
        dct:type          "TBX" ;
        tbx:encodingDesc  "<p type=\"XCSURI\">http://www.ttt.org/oscarstandards/tbx/TBXXCS.xcs</p>"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns##XMLL
iteral> ;
        tbx:sourceDesc    "<sourceDesc><p/></sourceDesc>"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns##XMLLiteral> .

:capital-en  a                 ontolex:LexicalEntry ;
        tbx:reliabilityCode    3 ;
        ontolex:canonicalForm  <https://term.tilde.com/terms/capital-en#CanonicalForm> ;
        ontolex:language       <http://www.lexvo.org/page/iso639-3/eng> ;
        ontolex:sense          <https://term.tilde.com/terms/capital-en#Sense> .

<https://term.tilde.com/terms/capital-en#CanonicalForm>
        ontolex:writtenRep  "capital"@en .

<https://term.tilde.com/terms/capitale-it#Sense>
        ontolex:reference  :2745688 , :1217415 .

<https://term.tilde.com/terms/capitale-it#CanonicalForm>
        ontolex:writtenRep  "capitale"@it .

<https://term.tilde.com/terms/Irlanda-it#CanonicalForm>
        ontolex:writtenRep  "Irlanda"@it .
```

### Simplified output
This example explains how to detect terms in a HTML document and obtain a simplified output by using [SPARQL filters](filtering.html).


curl HTTP Request

```
curl -X POST -d @docTest.html --header "Content-Type: text/html"  "{{ site.apiurl | prepend: site.url }}/e-terminology/tilde?outformat=xml&source-lang=en&target-lang=it&mode=full&filter=terminology-terms-only"
```

Terms in XML format

```
<?xml version="1.0"?>
<sparql xmlns="http://www.w3.org/2005/sparql-results#">
  <head>
    <variable name="language"/>
    <variable name="anchor"/>
    <variable name="confidence"/>
    <variable name="new_label"/>
    <variable name="new_uri"/>
  </head>
  <results>
    <result>
      <binding name="language">
        <literal>en</literal>
      </binding>
      <binding name="anchor">
        <literal>Ireland</literal>
      </binding>
      <binding name="confidence">
        <literal datatype="http://www.w3.org/2001/XMLSchema#integer">1</literal>
      </binding>
      <binding name="new_label">
        <literal>Ireland</literal>
      </binding>
      <binding name="new_uri">
        <literal>http://aims.fao.org/aos/agrovoc/c_3948, https://term.tilde.com/terms/615455</literal>
      </binding>
    </result>
    <result>
      <binding name="language">
        <literal>en</literal>
      </binding>
      <binding name="anchor">
        <literal>capital</literal>
      </binding>
      <binding name="confidence">
        <literal datatype="http://www.w3.org/2001/XMLSchema#integer">0</literal>
      </binding>
      <binding name="new_label">
        <literal>capital</literal>
      </binding>
      <binding name="new_uri">
        <literal>https://term.tilde.com/terms/1217415, http://aims.fao.org/aos/agrovoc/c_1271, https://term.tilde.com/terms/2745688</literal>
      </binding>
    </result>
  </results>
</sparql>
```

### Terms extraction with round-tripping

curl HTTP Request

```
curl -X POST -d @docTest.html --header "Content-Type: text/html" --header "Accept: text/html" "{{ site.apiurl | prepend: site.url }}/e-terminology/tilde?source-lang=en&target-lang=it&mode=full"
```

Enriched HTML file

```
<!DOCTYPE html>
<html lang="en"><head>    <meta charset="UTF-8">  </head>        <body>    <p>Dublin is the <span its-term="yes">capital</span> of <span its-term="yes">Ireland</span>!</p>  </body></html>
```

## Translation of HTML

This example shows how to invoke the e-Translation service over a HTML file.

HTML file

```
<!DOCTYPE html>
<html lang="en" >
  <head>
    <meta charset="utf-8" />
  </head>      
  <body>
    <p>Welcome to Dublin!</p>
  </body>
</html>
```

curl HTTP Request

```
curl -X POST -d @docTest-Translation.html --header "Content-Type: text/html" --header "Accept: text/n3" "{{ site.apiurl | prepend: site.url }}/e-translation/tilde?source-lang=en&target-lang=it"
```

Converted NIF

```
@prefix rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

<http://freme-project.eu/#char=0,18>
        a               nif:String , nif:RFC5147String , nif:Context ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "18"^^xsd:nonNegativeInteger ;
        nif:isString    "Welcome to Dublin!"@en ;
        dc:identifier   "1" ;
        itsrdf:target   "Benvenuti a Dublino."@it .
```

### Translation of HTML with round-tripping

The translation is not reported in the original HTML. The user is still allowed to specify `text/html` as output format, but no information about the translation are contained in the final HTML file.


## ITS properties and NIF files

This section shows how each supported format is converted to NIF, including the translation of ITS to itsrdf properties.
Note that all markups are discarded (excepting for ITS annotations) and only plain text is extracted.

### HTML

Original document, containing text-analysis ITS 2.0 properties.

```
<!DOCTYPE html>
<html lang="en" its-annotators-ref="text-analysis|http://enrycher.ijs.si">
  <head>
    <meta charset="utf-8" />
    <title>Text analysis: Local Test</title>
  </head>      
  <body>
    <p><span 
          its-ta-confidence="0.7"
          its-ta-class-ref="http://nerd.eurecom.fr/ontology#Location"  
          its-ta-ident-ref="http://dbpedia.org/resource/Dublin">Dublin</span> 
      is the <span 
          its-ta-source="Wordnet3.0" 
          its-ta-ident="301467919" 
          its-ta-confidence="0.5"
          >capital</span> of Ireland.</p>
  </body>
</html>
```

Converted NIF file

```
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

<http://freme-project.eu/#char=26,59>
        a                       nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf            "Dublin is the capital of Ireland."@en ;
        nif:beginIndex          "26"^^xsd:nonNegativeInteger ;
        nif:endIndex            "59"^^xsd:nonNegativeInteger ;
        nif:referenceContext    <http://freme-project.eu/#char=0,59> ;
        dc:identifier           "2" ;
        itsrdf:taAnnotatorsRef  <http://enrycher.ijs.si> .

<http://freme-project.eu/#char=26,32>
        a                       nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf            "Dublin"@en ;
        nif:beginIndex          "26"^^xsd:nonNegativeInteger ;
        nif:endIndex            "32"^^xsd:nonNegativeInteger ;
        nif:referenceContext    <http://freme-project.eu/#char=0,59> ;
        itsrdf:taAnnotatorsRef  <http://enrycher.ijs.si> ;
        itsrdf:taClassRef       <http://nerd.eurecom.fr/ontology#Location> ;
        itsrdf:taConfidence     "0.7"^^xsd:double ;
        itsrdf:taIdentRef       <http://dbpedia.org/resource/Dublin> .

<http://freme-project.eu/#char=40,47>
        a                       nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf            "capital"@en ;
        nif:beginIndex          "40"^^xsd:nonNegativeInteger ;
        nif:endIndex            "47"^^xsd:nonNegativeInteger ;
        nif:referenceContext    <http://freme-project.eu/#char=0,59> ;
        itsrdf:taAnnotatorsRef  <http://enrycher.ijs.si> ;
        itsrdf:taConfidence     "0.5"^^xsd:double ;
        itsrdf:taIdent          "301467919" ;
        itsrdf:taSource         "Wordnet3.0" .

<http://freme-project.eu/#char=0,25>
        a                       nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf            "Text analysis: Local Test"@en ;
        nif:beginIndex          "0"^^xsd:nonNegativeInteger ;
        nif:endIndex            "25"^^xsd:nonNegativeInteger ;
        nif:referenceContext    <http://freme-project.eu/#char=0,59> ;
        dc:identifier           "1" ;
        itsrdf:taAnnotatorsRef  <http://enrycher.ijs.si> .

<http://freme-project.eu/#char=0,59>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "59"^^xsd:nonNegativeInteger ;
        nif:isString    "Text analysis: Local Test Dublin is the capital of Ireland."@en .
```

### XML

Original document containing ITS annotations (Note that the ITS annotation management for XML files is still draft).

```
<?xml version="1.0"?>
<db>
  <its:rules xmlns:its="http://www.w3.org/2005/11/its" version="2.0">
    <its:storageSizeRule selector="//country" storageSize="25"
      storageEncoding="ISO-8859-1"/>
  </its:rules>
  <data>
    <country id="123">Papouasie-Nouvelle-Guinée</country>
    <country id="139">République Dominicaine</country>
  </data>
</db>
```

Converted NIF file

```
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

<http://freme-project.eu/#char=0,48>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "48"^^xsd:nonNegativeInteger ;
        nif:isString    "Papouasie-Nouvelle-Guinée République Dominicaine"@en .

<http://freme-project.eu/#char=26,48>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "République Dominicaine"@en ;
        nif:beginIndex        "26"^^xsd:nonNegativeInteger ;
        nif:endIndex          "48"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,48> ;
        dc:identifier         "2" .

<http://freme-project.eu/#char=0,25>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "Papouasie-Nouvelle-Guinée"@en ;
        nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
        nif:endIndex          "25"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,48> ;
        dc:identifier         "1" .
```

### XLIFF 1.2

Original document containing ITS annotations.

```
<?xml version="1.0" encoding="UTF-8" standalone="no"?><?xml-stylesheet type="text/xsl" href="file:///S:/PhilR/Rome/XliffToRWHtml5_target.xslt"?><xliff xmlns="urn:oasis:names:tc:xliff:document:1.2" xmlns:dl="http://www.digitallinguistics.com" xmlns:its="http://www.w3.org/2005/11/its" version="1.2">
	<file datatype="plaintext" original="PCWorldArticle.txt" source-language="en" target-language="it">
		<body>
			<trans-unit id="0" its:annotatorsRef="text-analysis|http://spotlight.dbpedia.org/" its:version="2.0">
				<source>Welcome to <mrk id="freme-1" its:taIdentRef="http://dbpedia.org/resource/Dublin" mtype="its:any">Dublin</mrk>!</source>
				<target state-qualifier="id-match">Benvenuti a Dublino!</target>
			</trans-unit>
			<trans-unit id="1" its:version="2.0">
				<source>This is my <mrk id="freme-2" mtype="term" >computer</mrk></source>
				<target state-qualifier="id-match">Questo è il mio computer</target>
			</trans-unit>
		</body>
	</file>
</xliff>
```

Converted NIF file

```
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

<http://freme-project.eu/#char=0,11>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "Welcome to "@en ;
        nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
        nif:endIndex          "11"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,88> ;
        dc:identifier         "1" .

<http://freme-project.eu/#char=43,54>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "This is my "@en ;
        nif:beginIndex        "43"^^xsd:nonNegativeInteger ;
        nif:endIndex          "54"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,88> ;
        dc:identifier         "5" .

<http://freme-project.eu/#char=12,18>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "Dublin"@en ;
        nif:beginIndex        "12"^^xsd:nonNegativeInteger ;
        nif:endIndex          "18"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,88> ;
        dc:identifier         "2" .

<http://freme-project.eu/#char=19,21>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "! "@en ;
        nif:beginIndex        "19"^^xsd:nonNegativeInteger ;
        nif:endIndex          "21"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,88> ;
        dc:identifier         "3" .

<http://freme-project.eu/#char=22,42>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "Benvenuti a Dublino!"@en ;
        nif:beginIndex        "22"^^xsd:nonNegativeInteger ;
        nif:endIndex          "42"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,88> ;
        dc:identifier         "4" .

<http://freme-project.eu/#char=64,88>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "Questo è il mio computer"@en ;
        nif:beginIndex        "64"^^xsd:nonNegativeInteger ;
        nif:endIndex          "88"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,88> ;
        dc:identifier         "7" .

<http://freme-project.eu/#char=0,88>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "88"^^xsd:nonNegativeInteger ;
        nif:isString    "Welcome to  Dublin !  Benvenuti a Dublino! This is my  computer Questo è il mio computer"@en .

<http://freme-project.eu/#char=55,63>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:anchorOf          "computer"@en ;
        nif:beginIndex        "55"^^xsd:nonNegativeInteger ;
        nif:endIndex          "63"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/#char=0,88> ;
        dc:identifier         "6" .
```

### ODT

Original file

![Image of ODT file]({{site.baseurl | prepend: site.url}}/img/odtFile.png)

Converted NIF file

```
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=315,346>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Section that is just protected."@en ;
        nif:beginIndex        "315"^^xsd:nonNegativeInteger ;
        nif:endIndex          "346"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "13" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=40,126>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Paragraph with an inserted script: Text of the script in any language. and text after."@en ;
        nif:beginIndex        "40"^^xsd:nonNegativeInteger ;
        nif:endIndex          "126"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "5" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=127,167>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Non-breaking space= , optional hyphen=­."@en ;
        nif:beginIndex        "127"^^xsd:nonNegativeInteger ;
        nif:endIndex          "167"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "6" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=186,202>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "After page break"@en ;
        nif:beginIndex        "186"^^xsd:nonNegativeInteger ;
        nif:endIndex          "202"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "8" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=30,39>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Text body"@en ;
        nif:beginIndex        "30"^^xsd:nonNegativeInteger ;
        nif:endIndex          "39"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "4" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=203,238>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Before line breakAfter line break."@en ;
        nif:beginIndex        "203"^^xsd:nonNegativeInteger ;
        nif:endIndex          "238"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "9" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=20,29>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Heading 3"@en ;
        nif:beginIndex        "20"^^xsd:nonNegativeInteger ;
        nif:endIndex          "29"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "3" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=279,314>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Section that is password-protected."@en ;
        nif:beginIndex        "279"^^xsd:nonNegativeInteger ;
        nif:endIndex          "314"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "12" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,9>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Heading 1"@en ;
        nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
        nif:endIndex          "9"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "1" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372>
        a               nif:String , nif:Context , nif:RFC5147String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "372"^^xsd:nonNegativeInteger ;
        nif:isString    "Heading 1 Heading 2 Heading 3 Text body Paragraph with an inserted script: Text of the script in any language. and text after. Non-breaking space= , optional hyphen=­. Before page break After page break Before line breakAfter line break. Before column break After column break. Section that is password-protected. Section that is just protected. Section with normal text."@en .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=168,185>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Before page break"@en ;
        nif:beginIndex        "168"^^xsd:nonNegativeInteger ;
        nif:endIndex          "185"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "7" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=259,278>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "After column break."@en ;
        nif:beginIndex        "259"^^xsd:nonNegativeInteger ;
        nif:endIndex          "278"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "11" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=10,19>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Heading 2"@en ;
        nif:beginIndex        "10"^^xsd:nonNegativeInteger ;
        nif:endIndex          "19"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "2" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=239,258>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Before column break"@en ;
        nif:beginIndex        "239"^^xsd:nonNegativeInteger ;
        nif:endIndex          "258"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "10" .

<http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=347,372>
        a                     nif:String , nif:RFC5147String , nif:Phrase ;
        nif:anchorOf          "Section with normal text."@en ;
        nif:beginIndex        "347"^^xsd:nonNegativeInteger ;
        nif:endIndex          "372"^^xsd:nonNegativeInteger ;
        nif:referenceContext  <http://freme-project.eu/~okapi-23_OpenOfficeFilter_7511887858581642861.tmp/#char=0,372> ;
        dc:identifier         "14" .
```



