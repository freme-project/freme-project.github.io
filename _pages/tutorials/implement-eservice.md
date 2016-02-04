---
title: Create a new e-Service
dropdown: Tutorials
layout: default
pos: 3.7
---

# Create a new e-Service

This tutorial explains how to implement a new e-Service in FREME. A FREME e-Service is an enrichment service for Natural Language Processing exposed via a REST API and that follows the NIF API specifications.

## Explanation of the e-Service

This e-Service enriches each text with a capitalized version of it. Like all FREME e-Services it takes NIF or plaintext as input. Example for NIF input is

```
@prefix nif:<http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .
@prefix itsrdf: <http://www.w3.org/2005/11/its/rdf#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
<http://example.org/document/1#char=0,21>
  a nif:String , nif:Context, nif:RFC5147String ;
  nif:isString "Welcome to Berlin"^^xsd:string;
  nif:beginIndex "0"^^xsd:nonNegativeInteger;
  nif:endIndex "21"^^xsd:nonNegativeInteger;
  nif:sourceUrl <http://differentday.blogspot.com/2007_01_01_archive.html>.
```

An example CURL request to the e-Service is

```
curl -X POST "http://localhost:8080/example-eservice/capitalize?input=hello+world&informat=text"
```

The output of above example is

```
@prefix xsd:   <http://www.w3.org/2001/XMLSchema#> .
@prefix nif:   <http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#> .

<http://freme-project.eu/#char=0,11>
        a               nif:RFC5147String , nif:Context , nif:String ;
        <http://freme-project.eu/capitalize>
                "HELLO WORLD"^^xsd:string ;
        nif:beginIndex  "0"^^xsd:nonNegativeInteger ;
        nif:endIndex    "11"^^xsd:nonNegativeInteger ;
        nif:isString    "hello world" .
```

## Example code

You can use this boilerplate code to create an e-Service in the [source code of the broker](https://github.com/freme-project/broker). The full code example (including imports) can be downloaded [here](https://drive.google.com/file/d/0B8CeKhHCOSqUTWdNTFNGdjlGdnM/view?usp=sharing). Similar e-Services are implement in the broker in the package eu.freme.broker.eservices.

<div style="background: #ffffff; overflow:auto;width:auto;border:solid gray;border-width:.1em .1em .1em .8em;padding:.2em .6em;"><!-- HTML generated using hilite.me --><table><tr><td><pre style="margin: 0; line-height: 125%"> 1
 2
 3
 4
 5
 6
 7
 8
 9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54</pre></td><td><pre style="margin: 0; line-height: 125%"><span style="color: #555555; font-weight: bold">@RestController</span>
<span style="color: #008800; font-weight: bold">public</span> <span style="color: #008800; font-weight: bold">class</span> <span style="color: #BB0066; font-weight: bold">ExampleEService</span> <span style="color: #008800; font-weight: bold">extends</span> BaseRestController <span style="color: #333333">{</span>

	<span style="color: #555555; font-weight: bold">@Autowired</span>
	RDFConversionService rdfConversionService<span style="color: #333333">;</span>

	Logger logger <span style="color: #333333">=</span> Logger<span style="color: #333333">.</span><span style="color: #0000CC">getLogger</span><span style="color: #333333">(</span>ExampleEService<span style="color: #333333">.</span><span style="color: #0000CC">class</span><span style="color: #333333">);</span>

	<span style="color: #555555; font-weight: bold">@RequestMapping</span><span style="color: #333333">(</span>value <span style="color: #333333">=</span> <span style="background-color: #fff0f0">&quot;/example-eservice/capitalize&quot;</span><span style="color: #333333">,</span> method <span style="color: #333333">=</span> RequestMethod<span style="color: #333333">.</span><span style="color: #0000CC">POST</span><span style="color: #333333">)</span>
	<span style="color: #008800; font-weight: bold">public</span> ResponseEntity<span style="color: #333333">&lt;</span>String<span style="color: #333333">&gt;</span> <span style="color: #0066BB; font-weight: bold">tildeTranslate</span><span style="color: #333333">(</span>
			<span style="color: #555555; font-weight: bold">@RequestHeader</span><span style="color: #333333">(</span>value <span style="color: #333333">=</span> <span style="background-color: #fff0f0">&quot;Accept&quot;</span><span style="color: #333333">,</span> required <span style="color: #333333">=</span> <span style="color: #008800; font-weight: bold">false</span><span style="color: #333333">)</span> String acceptHeader<span style="color: #333333">,</span>
			<span style="color: #555555; font-weight: bold">@RequestHeader</span><span style="color: #333333">(</span>value <span style="color: #333333">=</span> <span style="background-color: #fff0f0">&quot;Content-Type&quot;</span><span style="color: #333333">,</span> required <span style="color: #333333">=</span> <span style="color: #008800; font-weight: bold">false</span><span style="color: #333333">)</span> String contentTypeHeader<span style="color: #333333">,</span>
			<span style="color: #555555; font-weight: bold">@RequestBody</span><span style="color: #333333">(</span>required <span style="color: #333333">=</span> <span style="color: #008800; font-weight: bold">false</span><span style="color: #333333">)</span> String postBody<span style="color: #333333">,</span>
			<span style="color: #555555; font-weight: bold">@RequestParam</span> Map<span style="color: #333333">&lt;</span>String<span style="color: #333333">,</span> String<span style="color: #333333">&gt;</span> parameterMap<span style="color: #333333">)</span> <span style="color: #333333">{</span>

		NIFParameterSet parameters <span style="color: #333333">=</span> <span style="color: #008800; font-weight: bold">this</span><span style="color: #333333">.</span><span style="color: #0000CC">normalizeNif</span><span style="color: #333333">(</span>postBody<span style="color: #333333">,</span> acceptHeader<span style="color: #333333">,</span>
				contentTypeHeader<span style="color: #333333">,</span> parameterMap<span style="color: #333333">,</span> <span style="color: #008800; font-weight: bold">false</span><span style="color: #333333">);</span>

		<span style="color: #888888">// create rdf model</span>
		String plaintext <span style="color: #333333">=</span> <span style="color: #008800; font-weight: bold">null</span><span style="color: #333333">;</span>
		Model inputModel <span style="color: #333333">=</span> ModelFactory<span style="color: #333333">.</span><span style="color: #0000CC">createDefaultModel</span><span style="color: #333333">();</span>

		<span style="color: #008800; font-weight: bold">if</span> <span style="color: #333333">(!</span>parameters<span style="color: #333333">.</span><span style="color: #0000CC">getInformat</span><span style="color: #333333">().</span><span style="color: #0000CC">equals</span><span style="color: #333333">(</span>
				RDFConstants<span style="color: #333333">.</span><span style="color: #0000CC">RDFSerialization</span><span style="color: #333333">.</span><span style="color: #0000CC">PLAINTEXT</span><span style="color: #333333">))</span> <span style="color: #333333">{</span>
			<span style="color: #888888">// input is nif</span>
			<span style="color: #008800; font-weight: bold">try</span> <span style="color: #333333">{</span>
				inputModel <span style="color: #333333">=</span> <span style="color: #008800; font-weight: bold">this</span><span style="color: #333333">.</span><span style="color: #0000CC">unserializeNif</span><span style="color: #333333">(</span>parameters<span style="color: #333333">.</span><span style="color: #0000CC">getInput</span><span style="color: #333333">(),</span>
						parameters<span style="color: #333333">.</span><span style="color: #0000CC">getInformat</span><span style="color: #333333">());</span>
			<span style="color: #333333">}</span> <span style="color: #008800; font-weight: bold">catch</span> <span style="color: #333333">(</span>Exception e<span style="color: #333333">)</span> <span style="color: #333333">{</span>
				logger<span style="color: #333333">.</span><span style="color: #0000CC">error</span><span style="color: #333333">(</span><span style="background-color: #fff0f0">&quot;failed&quot;</span><span style="color: #333333">,</span> e<span style="color: #333333">);</span>
				<span style="color: #008800; font-weight: bold">throw</span> <span style="color: #008800; font-weight: bold">new</span> <span style="color: #0066BB; font-weight: bold">BadRequestException</span><span style="color: #333333">(</span><span style="background-color: #fff0f0">&quot;Error parsing NIF input&quot;</span><span style="color: #333333">);</span>
			<span style="color: #333333">}</span>
		<span style="color: #333333">}</span> <span style="color: #008800; font-weight: bold">else</span> <span style="color: #333333">{</span>
			<span style="color: #888888">// input is plaintext</span>
			plaintext <span style="color: #333333">=</span> parameters<span style="color: #333333">.</span><span style="color: #0000CC">getInput</span><span style="color: #333333">();</span>
			rdfConversionService<span style="color: #333333">.</span><span style="color: #0000CC">plaintextToRDF</span><span style="color: #333333">(</span>inputModel<span style="color: #333333">,</span> plaintext<span style="color: #333333">,</span> <span style="color: #008800; font-weight: bold">null</span><span style="color: #333333">,</span>
					parameters<span style="color: #333333">.</span><span style="color: #0000CC">getPrefix</span><span style="color: #333333">());</span>
		<span style="color: #333333">}</span>

		<span style="color: #008800; font-weight: bold">try</span> <span style="color: #333333">{</span>
			Property property <span style="color: #333333">=</span> inputModel<span style="color: #333333">.</span><span style="color: #0000CC">getProperty</span><span style="color: #333333">(</span><span style="background-color: #fff0f0">&quot;http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#isString&quot;</span><span style="color: #333333">);</span>	
			Statement stmt <span style="color: #333333">=</span> inputModel<span style="color: #333333">.</span><span style="color: #0000CC">listStatements</span><span style="color: #333333">((</span>Resource<span style="color: #333333">)</span><span style="color: #008800; font-weight: bold">null</span><span style="color: #333333">,</span> property<span style="color: #333333">,</span> <span style="color: #333333">(</span>String<span style="color: #333333">)</span><span style="color: #008800; font-weight: bold">null</span><span style="color: #333333">).</span><span style="color: #0000CC">next</span><span style="color: #333333">();</span>
			plaintext <span style="color: #333333">=</span> stmt<span style="color: #333333">.</span><span style="color: #0000CC">getLiteral</span><span style="color: #333333">().</span><span style="color: #0000CC">getString</span><span style="color: #333333">();</span>
			String enrichment <span style="color: #333333">=</span> plaintext<span style="color: #333333">.</span><span style="color: #0000CC">toUpperCase</span><span style="color: #333333">();</span>
			Property enrichmentProperty <span style="color: #333333">=</span> inputModel<span style="color: #333333">.</span><span style="color: #0000CC">createProperty</span><span style="color: #333333">(</span><span style="background-color: #fff0f0">&quot;http://freme-project.eu/capitalize&quot;</span><span style="color: #333333">);</span>		
			stmt<span style="color: #333333">.</span><span style="color: #0000CC">getSubject</span><span style="color: #333333">().</span><span style="color: #0000CC">addLiteral</span><span style="color: #333333">(</span>enrichmentProperty<span style="color: #333333">,</span> enrichment<span style="color: #333333">);</span>
		<span style="color: #333333">}</span> <span style="color: #008800; font-weight: bold">catch</span> <span style="color: #333333">(</span>Exception e<span style="color: #333333">)</span> <span style="color: #333333">{</span>
			logger<span style="color: #333333">.</span><span style="color: #0000CC">error</span><span style="color: #333333">(</span><span style="background-color: #fff0f0">&quot;exception was thrown&quot;</span><span style="color: #333333">,</span> e<span style="color: #333333">);</span>
			<span style="color: #008800; font-weight: bold">throw</span> <span style="color: #008800; font-weight: bold">new</span> <span style="color: #0066BB; font-weight: bold">InternalServerErrorException</span><span style="color: #333333">();</span>
		<span style="color: #333333">}</span>

		<span style="color: #008800; font-weight: bold">return</span> <span style="color: #0066BB; font-weight: bold">createSuccessResponse</span><span style="color: #333333">(</span>inputModel<span style="color: #333333">,</span> parameters<span style="color: #333333">.</span><span style="color: #0000CC">getOutformat</span><span style="color: #333333">());</span>
	<span style="color: #333333">}</span>
<span style="color: #333333">}</span>
</pre></td></tr></table></div>


* Line 1 advises Spring MVC to create a REST endpoint out of this class
* Line 9 defines the URL of the REST endpoint. All FREME enrichment services should be accessible via HTTP POST.
* Line 10-14 define the input parameters of the request using Spring MVC syntax.
* Line 16 extracts all the standard NIF parameters from the request. It makes sure that the request is compliant with the [NIF API specification](http://persistence.uni-leipzig.org/nlp2rdf/specification/api.html).
* The broker accepts many different input formats, including plaintext and several RDF serialization formats. Line 19-38 unifies all these approaches by creating a Jena model from the several input formats.
* Line 41-46 adds the enrichment to the RDF model. It is surrounded by a try catch block. The reason for this try-catch block is that exceptions in the underlying services should not be passed to the user. The message of the exception might reveal internal information to the user. Or the error message of the internal exception is so confusing that is does not help the user. Instead they should be caught and well controlled error messages should be thrown. The most common errors are BadRequestException, InternalServerException and ExternalServiceFailedException. You should only send exceptions from the package eu.freme.broker.exception to the user. These exception also contain an annotation that controls the http response code send to the user.
* Line 52 returns a succesful response in the output format that the user specified.

Useful links:

* [source code of the broker](https://github.com/freme-project/broker)
* [Documentation of Spring MVC](http://docs.spring.io/spring-framework/docs/current/spring-framework-reference/html/mvc.html)
* [NIF API specification](http://persistence.uni-leipzig.org/nlp2rdf/specification/api.html)

## Embedding the e-Service in FREME

FREME differentiates between two kinds of e-Services. e-Services hosted on FREME and external services.

An external service is a service that is hosted on another server and that is accessible via a web interface. So FREME proxies the requests it receives to this server. In this case FREME adds NIF compatibility and more input / output formats to the external service. This is the easiest way of integrating an e-Service into FREME. In this case you can directly implement the API call in line 41-46 of the example code.

An e-Service hosted on FREME is more complicated. In this case FREME does not simply redirect the call to an external service but the code that produces the enrichment resides on FREME also. We suggest to implement this enrichment service as a separate project and as a Java library. It should be implemented as a spring bean for easy integration in FREME. Then the e-Service calls this Java library.
