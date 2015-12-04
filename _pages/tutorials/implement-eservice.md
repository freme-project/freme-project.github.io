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

```
@RestController
public class ExampleEService extends BaseRestController {

	@Autowired
	RDFConversionService rdfConversionService;

	Logger logger = Logger.getLogger(ExampleEService.class);

	@RequestMapping(value = "/example-eservice/capitalize", method = RequestMethod.POST)
	public ResponseEntity<String> tildeTranslate(
			@RequestHeader(value = "Accept", required = false) String acceptHeader,
			@RequestHeader(value = "Content-Type", required = false) String contentTypeHeader,
			@RequestBody(required = false) String postBody,
			@RequestParam Map<String, String> parameterMap) {

		NIFParameterSet parameters = this.normalizeNif(postBody, acceptHeader,
				contentTypeHeader, parameterMap, false);

		// create rdf model
		String plaintext = null;
		Model inputModel = ModelFactory.createDefaultModel();

		if (!parameters.getInformat().equals(
				RDFConstants.RDFSerialization.PLAINTEXT)) {
			// input is nif
			try {
				inputModel = this.unserializeNif(parameters.getInput(),
						parameters.getInformat());
			} catch (Exception e) {
				logger.error("failed", e);
				throw new BadRequestException("Error parsing NIF input");
			}
		} else {
			// input is plaintext
			plaintext = parameters.getInput();
			rdfConversionService.plaintextToRDF(inputModel, plaintext, null,
					parameters.getPrefix());
		}

		try {
			Property property = inputModel.getProperty("http://persistence.uni-leipzig.org/nlp2rdf/ontologies/nif-core#isString");	
			Statement stmt = inputModel.listStatements((Resource)null, property, (String)null).next();
			plaintext = stmt.getLiteral().getString();
			String enrichment = plaintext.toUpperCase();
			Property enrichmentProperty = inputModel.createProperty("http://freme-project.eu/capitalize");		
			stmt.getSubject().addLiteral(enrichmentProperty, enrichment);
		} catch (Exception e) {
			logger.error("exception was thrown", e);
			throw new InternalServerErrorException();
		}

		return createSuccessResponse(inputModel, parameters.getOutformat());
	}
}
```  

* Line 1 advises Spring MVC to create a REST endpoint out of this class
* Line 9 defines the URL of the REST endpoint. All FREME enrichment services should be accessible via HTTP POST.
* Line 10-14 define the input parameters of the request using Spring MVC syntax.
* Line 16 extracts all the standard NIF parameters from the request. It makes sure that the request is compliant with the [NIF API specification](http://persistence.uni-leipzig.org/nlp2rdf/specification/api.html).
* The broker accepts many different input formats, including plaintext and several RDF serialization formats. Line 19-38 unifies all these approaches by creating a Jena model from the several input formats.
* Line 41-46 creates the response. Line 40 performs the actually enrichment. It is surrounded by a try catch block. The reason for this try-catch block is that exceptions in the underlying services should not be passed to the user. The message of the exception might reveal internal information to the user. Or the error message of the internal exception is so confusing that is does not help the user. Instead they should be caught and well controlled error messages should be thrown. The most common errors are BadRequestException, InternalServerException and ExternalServiceFailedException. You should only send exceptions from the package eu.freme.broker.exception to the user. These exception also contain an annotation that controls the http response code send to the user.
* Line 48 returns a succesful response in the output format that the user specified.

Useful links:

* [source code of the broker](https://github.com/freme-project/broker)
* [Documentation of Spring MVC](http://docs.spring.io/spring-framework/docs/current/spring-framework-reference/html/mvc.html)
* [NIF API specification](http://persistence.uni-leipzig.org/nlp2rdf/specification/api.html)

## Embedding the e-Service in FREME

FREME differentiates between two kinds of e-Services. e-Services hosted on FREME and external services.

An external service is a service that is hosted on another server and that is accessible via a web interface. So FREME proxies a the requests it receives to this server. In this case FREME adds NIF compatibility and more input / output formats to the external service. This is the easiest way of integrating an e-Service into FREME. In this case you can directly implement the API call in line 46 of the example code.

An e-Service hosted on FREME is more complicated. In this case FREME does not simply redirect the call to an external service but it the code that produces the enrichment resides on FREME also. We suggest to implement this enrichment service as a separate project and as a Java library. It should be implemented as a spring bean for easy integration in FREME. Then the e-Service calls this Java library in line 46 of the example code. 
