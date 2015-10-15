---
layout: page
title: e-Internationalization Service
dropdown: Knowledge Base
pos: 4.7
---

# e-Internationalization

FREME e-Services work with either plain text or NIF files. But what if the final user wants to enrich a HTML file and doesn’t know how to convert it to NIF? This is what the e-Internationalization service has been planned for. 

The e-Internationalization service provides methods for converting following formats to NIF:

  * HTML – MIME-type: text/html
  *	XML – MIME-type: text/xml
  *	XLIFF 1.2 – MIME-type: application/x-xliff+xml
  *	ODT – MIME-type: application/x-openoffice
  
If the original document contains ITS 2.0 tags, they are translated to proper NIF properties from the itsrdf domain.

## Conversion to NIF


This section describes some examples of input files and expected output for each supported format. Note that all markups are discarded (excepting for ITS annotations) and only plain text is extracted.

### HTML

Original document, containing text-analysis ITS 2.0 tags.
```
&lt;!DOCTYPE html&gt;
&lt;html lang=&quot;en&quot; its-annotators-ref=&quot;text-analysis|http://enrycher.ijs.si&quot;&gt;
  &lt;head&gt;
    &lt;meta charset=&quot;utf-8&quot; /&gt;
    &lt;title>Text analysis: Local Test&lt;/title&gt;
  &lt;\head&gt;      
  &lt;body&gt;
    &lt;p&gt;&lt;span 
          its-ta-confidence=&quot;0.7&quot;
          its-ta-class-ref=&quot;http://nerd.eurecom.fr/ontology#Location&quot;  
          its-ta-ident-ref=&quot;http://dbpedia.org/resource/Dublin&quot;&gt;Dublin&lt;/span&gt;
      is the &lt;span 
          its-ta-source=&quot;Wordnet3.0&quot; 
          its-ta-ident=&quot;301467919&quot; 
          its-ta-confidence=&quot;0.5&quot;
          >capital&lt;/span&gt; of Ireland.&lt;/p&gt;
  &lt;/body&gt;
&lt;/html&gt;
```

Converted NIF file
```
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

<http://freme-project.eu/#char=26,59>
        a                       nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext    "http://freme-project.eu/#char=0,59" ;
        nif:anchorOf            "Dublin is the capital of Ireland."@en ;
        nif:beginIndex          "26"^^xsd:nonNegativeInteger ;
        nif:endIndex            "59"^^xsd:nonNegativeInteger ;
        dc:identifier           "2" ;
        itsrdf:taAnnotatorsRef  <http://enrycher.ijs.si> .

<http://freme-project.eu/#char=26,32>
        a                       nif:String , nif:RFC5147String , nif:Phrase ;
        nif:ReferenceContext    "http://freme-project.eu/#char=0,59" ;
        nif:anchorOf            "Dublin"@en ;
        nif:beginIndex          "26"^^xsd:nonNegativeInteger ;
        nif:endIndex            "32"^^xsd:nonNegativeInteger ;
        itsrdf:taAnnotatorsRef  <http://enrycher.ijs.si> ;
        itsrdf:taClassRef       <http://nerd.eurecom.fr/ontology#Location> ;
        itsrdf:taConfidence     "0.7"^^xsd:double ;
        itsrdf:taIdentRef       <http://dbpedia.org/resource/Dublin> .

<http://freme-project.eu/#char=40,47>
        a                       nif:String , nif:RFC5147String , nif:Phrase ;
        nif:ReferenceContext    "http://freme-project.eu/#char=0,59" ;
        nif:anchorOf            "capital"@en ;
        nif:beginIndex          "40"^^xsd:nonNegativeInteger ;
        nif:endIndex            "47"^^xsd:nonNegativeInteger ;
        itsrdf:taAnnotatorsRef  <http://enrycher.ijs.si> ;
        itsrdf:taConfidence     "0.5"^^xsd:double ;
        itsrdf:taIdent          "301467919" ;
        itsrdf:taSource         "Wordnet3.0" .

<http://freme-project.eu/#char=0,25>
        a                       nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext    "http://freme-project.eu/#char=0,59" ;
        nif:anchorOf            "Text analysis: Local Test"@en ;
        nif:beginIndex          "0"^^xsd:nonNegativeInteger ;
        nif:endIndex            "25"^^xsd:nonNegativeInteger ;
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

<http://example.org/test2-storagesize.xml/#char=0,25>
        a                       nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext    "http://example.org/test2-storagesize.xml/#char=0,48" ;
        nif:anchorOf            "Papouasie-Nouvelle-Guinée"@en ;
        nif:beginIndex          "0"^^xsd:nonNegativeInteger ;
        nif:endIndex            "25"^^xsd:nonNegativeInteger ;
        dc:identifier           "1" ;
        itsrdf:lineBreakType    "lf" ;
        itsrdf:storageEncoding  "ISO-8859-1" ;
        itsrdf:storageSize      "25"^^xsd:unsignedInt .

<http://example.org/test2-storagesize.xml/#char=26,48>
        a                       nif:RFC5147String , nif:Phrase , nif:String ;
        nif:ReferenceContext    "http://example.org/test2-storagesize.xml/#char=0,48" ;
        nif:anchorOf            "République Dominicaine"@en ;
        nif:beginIndex          "26"^^xsd:nonNegativeInteger ;
        nif:endIndex            "48"^^xsd:nonNegativeInteger ;
        dc:identifier           "2" ;
        itsrdf:lineBreakType    "lf" ;
        itsrdf:storageEncoding  "ISO-8859-1" ;
        itsrdf:storageSize      "25"^^xsd:unsignedInt .

<http://example.org/test2-storagesize.xml/#char=0,48>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "48"^^xsd:nonNegativeInteger ;
        nif:isString    "Papouasie-Nouvelle-Guinée République Dominicaine"@en .

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

<http://example.org/entityAndTerm.xlf/target-it#char=21,45>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/entityAndTerm.xlf/target-it#char=0,45" ;
        nif:anchorOf          "Questo è il mio computer"@en ;
        nif:beginIndex        "21"^^xsd:nonNegativeInteger ;
        nif:endIndex          "45"^^xsd:nonNegativeInteger ;
        dc:identifier         "1" .

<http://example.org/entityAndTerm.xlf/#char=11,17>
        a                       nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext    "http://example.org/entityAndTerm.xlf/#char=0,38" ;
        nif:anchorOf            "Dublin"@en ;
        nif:beginIndex          "11"^^xsd:nonNegativeInteger ;
        nif:endIndex            "17"^^xsd:nonNegativeInteger ;
        itsrdf:taAnnotatorsRef  <http://spotlight.dbpedia.org/> ;
        itsrdf:taIdentRef       <http://dbpedia.org/resource/Dublin> .

<http://example.org/entityAndTerm.xlf/#char=19,38>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/entityAndTerm.xlf/#char=0,38" ;
        nif:anchorOf          "This is my computer"@en ;
        nif:beginIndex        "19"^^xsd:nonNegativeInteger ;
        nif:endIndex          "38"^^xsd:nonNegativeInteger ;
        dc:identifier         "1" ;
        itsrdf:target         <http://example.org/entityAndTerm.xlf/target-it#char=21,45> .

<http://example.org/entityAndTerm.xlf/#char=0,18>
        a                       nif:RFC5147String , nif:Phrase , nif:String ;
        nif:ReferenceContext    "http://example.org/entityAndTerm.xlf/#char=0,38" ;
        nif:anchorOf            "Welcome to Dublin!"@en ;
        nif:beginIndex          "0"^^xsd:nonNegativeInteger ;
        nif:endIndex            "18"^^xsd:nonNegativeInteger ;
        dc:identifier           "0" ;
        itsrdf:taAnnotatorsRef  <http://spotlight.dbpedia.org/> ;
        itsrdf:target           <http://example.org/entityAndTerm.xlf/target-it#char=0,20> .

<http://example.org/entityAndTerm.xlf/#char=30,38>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/entityAndTerm.xlf/#char=0,38" ;
        nif:anchorOf          "computer"@en ;
        nif:beginIndex        "30"^^xsd:nonNegativeInteger ;
        nif:endIndex          "38"^^xsd:nonNegativeInteger ;
        itsrdf:term           "yes" .

<http://example.org/entityAndTerm.xlf/target-it#char=0,20>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/entityAndTerm.xlf/target-it#char=0,45" ;
        nif:anchorOf          "Benvenuti a Dublino!"@en ;
        nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
        nif:endIndex          "20"^^xsd:nonNegativeInteger ;
        dc:identifier         "0" .

<http://example.org/entityAndTerm.xlf/#char=0,38>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "38"^^xsd:nonNegativeInteger ;
        nif:isString    "Welcome to Dublin! This is my computer"@en .

<http://example.org/entityAndTerm.xlf/target-it#char=0,45>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "45"^^xsd:nonNegativeInteger ;
        nif:isString    "Benvenuti a Dublino! Questo è il mio computer"@en .
```

### ODT

Original file
![Image of ODT file]
(https://github.com/freme-project/Documentation/blob/master/img/odtFile.png)


Converted NIF file
```
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix dc:    <http://purl.org/dc/elements/1.1/> .

<http://example.org/TestDocument02.odt/#char=30,39>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Text body"@en ;
        nif:beginIndex        "30"^^xsd:nonNegativeInteger ;
        nif:endIndex          "39"^^xsd:nonNegativeInteger ;
        dc:identifier         "4" .

<http://example.org/TestDocument02.odt/#char=239,258>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Before column break"@en ;
        nif:beginIndex        "239"^^xsd:nonNegativeInteger ;
        nif:endIndex          "258"^^xsd:nonNegativeInteger ;
        dc:identifier         "10" .

<http://example.org/TestDocument02.odt/#char=347,372>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Section with normal text."@en ;
        nif:beginIndex        "347"^^xsd:nonNegativeInteger ;
        nif:endIndex          "372"^^xsd:nonNegativeInteger ;
        dc:identifier         "14" .

<http://example.org/TestDocument02.odt/#char=279,314>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Section that is password-protected."@en ;
        nif:beginIndex        "279"^^xsd:nonNegativeInteger ;
        nif:endIndex          "314"^^xsd:nonNegativeInteger ;
        dc:identifier         "12" .

<http://example.org/TestDocument02.odt/#char=315,346>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Section that is just protected."@en ;
        nif:beginIndex        "315"^^xsd:nonNegativeInteger ;
        nif:endIndex          "346"^^xsd:nonNegativeInteger ;
        dc:identifier         "13" .

<http://example.org/TestDocument02.odt/#char=168,185>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Before page break"@en ;
        nif:beginIndex        "168"^^xsd:nonNegativeInteger ;
        nif:endIndex          "185"^^xsd:nonNegativeInteger ;
        dc:identifier         "7" .

<http://example.org/TestDocument02.odt/#char=127,167>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Non-breaking space= , optional hyphen=­."@en ;
        nif:beginIndex        "127"^^xsd:nonNegativeInteger ;
        nif:endIndex          "167"^^xsd:nonNegativeInteger ;
        dc:identifier         "6" .

<http://example.org/TestDocument02.odt/#char=186,202>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "After page break"@en ;
        nif:beginIndex        "186"^^xsd:nonNegativeInteger ;
        nif:endIndex          "202"^^xsd:nonNegativeInteger ;
        dc:identifier         "8" .

<http://example.org/TestDocument02.odt/#char=0,372>
        a               nif:RFC5147String , nif:Context , nif:String ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "372"^^xsd:nonNegativeInteger ;
        nif:isString    "Heading 1 Heading 2 Heading 3 Text body Paragraph with an inserted script: Text of the script in any language. and text after. Non-breaking space= , optional hyphen=­. Before page break After page break Before line breakAfter line break. Before column break After column break. Section that is password-protected. Section that is just protected. Section with normal text."@en .

<http://example.org/TestDocument02.odt/#char=20,29>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Heading 3"@en ;
        nif:beginIndex        "20"^^xsd:nonNegativeInteger ;
        nif:endIndex          "29"^^xsd:nonNegativeInteger ;
        dc:identifier         "3" .

<http://example.org/TestDocument02.odt/#char=203,238>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Before line breakAfter line break."@en ;
        nif:beginIndex        "203"^^xsd:nonNegativeInteger ;
        nif:endIndex          "238"^^xsd:nonNegativeInteger ;
        dc:identifier         "9" .

<http://example.org/TestDocument02.odt/#char=10,19>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Heading 2"@en ;
        nif:beginIndex        "10"^^xsd:nonNegativeInteger ;
        nif:endIndex          "19"^^xsd:nonNegativeInteger ;
        dc:identifier         "2" .

<http://example.org/TestDocument02.odt/#char=259,278>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "After column break."@en ;
        nif:beginIndex        "259"^^xsd:nonNegativeInteger ;
        nif:endIndex          "278"^^xsd:nonNegativeInteger ;
        dc:identifier         "11" .

<http://example.org/TestDocument02.odt/#char=40,126>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Paragraph with an inserted script: Text of the script in any language. and text after."@en ;
        nif:beginIndex        "40"^^xsd:nonNegativeInteger ;
        nif:endIndex          "126"^^xsd:nonNegativeInteger ;
        dc:identifier         "5" .

<http://example.org/TestDocument02.odt/#char=0,9>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://example.org/TestDocument02.odt/#char=0,372" ;
        nif:anchorOf          "Heading 1"@en ;
        nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
        nif:endIndex          "9"^^xsd:nonNegativeInteger ;
        dc:identifier         "1" .
```

### Note on ITS tags

Some ITS 2.0 categories are not supported: they are not translated to itsrdf properties. Known unsupported categories are:

* Translate for XLIFF files
* Translate, Locale Filter, MT Confidence and Domain for HTML
* ITS tags support for XML files is still draft. Some categories could not be translated. At the moment a list of unsupported tags is not available.

## Roundtripping

The e-Internationalization service provides also a method for converting back the enriched NIF file to the original document format. At the moment this functionality is only available for HTML files.

### How does it work?

When converting a HTML file to NIF a second NIF file is produced, containing a context that also includes markups. Let’s call such a file “skeleton”. The skeleton file is locally saved while the first NIF file (without markups) is submitted to enriching FREME e-services. Then the enriched NIF file and the skeleton file are submitted to the e-Internationalization service which returns the original HTML document with the addition of enrichment annotations.

### Roundtripping example

A HTML file is converted to NIF and enriched with the e-Entity service. Finally it is converted back to the original format. 

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
        nif:ReferenceContext  "http://freme-project.eu/#char=0,31" ;
        nif:anchorOf          "Welcome to Dublin"@en ;
        nif:beginIndex        "14"^^xsd:nonNegativeInteger ;
        nif:endIndex          "31"^^xsd:nonNegativeInteger ;
        dc:identifier         "2" .

<http://freme-project.eu/#char=0,13>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://freme-project.eu/#char=0,31" ;
        nif:anchorOf          "Roundtripping"@en ;
        nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
        nif:endIndex          "13"^^xsd:nonNegativeInteger ;
        dc:identifier         "1" .
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
        nif:ReferenceContext  "http://freme-project.eu/#char=0,31" ;
        nif:anchorOf          "Welcome to Dublin"@en ;
        nif:beginIndex        "14"^^xsd:nonNegativeInteger ;
        nif:endIndex          "31"^^xsd:nonNegativeInteger ;
        dc:identifier         "2" .

<http://freme-project.eu/#char=0,13>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://freme-project.eu/#char=0,31" ;
        nif:anchorOf          "Roundtripping"@en ;
        nif:beginIndex        "0"^^xsd:nonNegativeInteger ;
        nif:endIndex          "13"^^xsd:nonNegativeInteger ;
        dc:identifier         "1" .
		
<http://freme-project.eu/#char=25,31>
        a                     nif:Phrase , nif:RFC5147String , nif:String ;
        nif:ReferenceContext  "http://freme-project.eu/#char=0,31" ;
        nif:anchorOf          "Dublin"@en ;
        nif:beginIndex        "25"^^xsd:nonNegativeInteger ;
        nif:endIndex          "31"^^xsd:nonNegativeInteger ;
        itsrdf:taIdentRef <http://http://dbpedia.org/resource/Dublin> .
```

Original enriched HTML file. Note that some new lines get lost. Anyway it is not relevant for new lines don’t affect the HTML file appearance in the browser.
```
<!DOCTYPE html>
<html><head>
	<title>Roundtripping</title>
</head>
<body>
<p>Welcome to <span its-ta-ident-ref="http://http://dbpedia.org/resource/Dublin">Dublin</span></p>

</body></html>
```