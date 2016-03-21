---
layout: page
title: How to write an e-Service
dropdown: Knowledge Base, FREME for Developers
pos: 4.9
---

# How to write an e-Service

This tutorial explains how to implement a new e-Service in FREME. A FREME e-Service is an enrichment service for Natural Language Processing exposed via a REST API and that follows the NIF API specifications. You can find the full source code of the tutorial in the e-capitalization project in the [freme-examples](https://github.com/freme-project/freme-examples) GitHub repository.

# Table of Contents

* [Explanation of the e-Service](#explanation-of-the-e-service)
* [File / folder structure](#file--folder-structure)
* [pom.xml explained](#pomxml-explained)
* [ECapitalizationService.java explained](#ecapitalizationservicejava-explained)
* [e-capitalization.xml explained](#e-capitalizationxml-explained)
* [ECapitalizationServiceTest.java explained](#ecapitalizationservicetestjava-explained)
* [e-capitalization-test-package.xml explained](#e-capitalization-test-packagexml-explained)

# Explanation of the e-Service

This e-Service is called e-Capitalization. It enriches text with a capitalized version of it. Like all FREME e-Services it takes NIF or plaintext as input. Example for NIF input is

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
curl -X POST "http://localhost:8080/e-capitalize?input=hello+world&informat=text"
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

# File / folder structure

The example project consists of 5 files:

* [ECapitalizationService.java](https://github.com/freme-project/freme-examples/blob/master/e-capitalization/src/main/java/eu/freme/eservices/example/ECapitalizationService.java) contains the business logic of the e-Service. Here it creates a REST endpoint and performs the enrichment.
* [ECapitalizationServiceTest.java](https://github.com/freme-project/freme-examples/blob/master/e-capitalization/src/test/java/eu/freme/eservices/example/ECapitalizationServiceTest.java) is a unit test for ECapitalizationService.
* [pom.xml](https://github.com/freme-project/freme-examples/blob/master/e-capitalization/pom.xml) is the maven configuration file of the project.
* [e-capitalization.xml](https://github.com/freme-project/freme-examples/blob/master/e-capitalization/src/main/resources/spring-configurations/e-capitalization.xml) is the spring configuration file that needs to be imported in order to add the e-Capitalization service to a FREME package.
* [e-capitalization-test-package.xml](https://github.com/freme-project/freme-examples/blob/master/e-capitalization/src/test/resources/e-capitalization-test-package.xml) is a FREME package that starts only e-Capitalization service for the unit tests.

# pom.xml explained

The [pom.xml](https://github.com/freme-project/freme-examples/blob/master/e-capitalization/pom.xml) file performs the Maven setup of the code.

* It inherits from `eu.freme-e-services.e-service-parent`. All FREME e-Services inherit from this artifact. This sets up some common settings, e.g. the dependency on FREMECommon.
* It defines dependency on the test-helper artifact. Here you can include dependencies on other FREME b-Services or e-Services also.
* Then it adds the FREME repository so Maven can find all the artifacts e-services-parent and test-helper.

# ECapitalizationService.java explained

This guide explains the source code in [ECapitalizationService.java](https://github.com/freme-project/freme-examples/blob/master/e-capitalization/src/main/java/eu/freme/eservices/example/ECapitalizationService.java). It creates a REST endpoint according to the [NIF specifications](http://persistence.uni-leipzig.org/nlp2rdf/specification/api.html) that accepts as input plaintext and RDF in various serialization formats. It then performs the enrichment and adds the enrichment to the RDF model. Then it returns the response to the client. The response can be send in various RDF serialization formats.

e-Capitalization is a single class that starts with these source code lines:

```
@RestController
public class ECapitalizationService extends BaseRestController {

	Logger logger = Logger.getLogger(ECapitalizationService.class);

	@Autowired
	RestHelper restHelper;

	@Autowired
	RDFConversionService rdfConversionService;
```

The annotation @RestController tells Spring to look for rest endpoints in this class. Then the class ECapitalizationService extends BaseRestController. This adds some convenience methods, e.g. a custom exception handler. Then a logger is initialized. FREME uses the [Apache Log4j](http://logging.apache.org/log4j/2.x/) logging library.

Then two spring beans are autowired. FREME internally relies heavily on Spring and Dependency Injection. An explanation of dependency injection is out of scope of this tutorial. Extensive documentation on the topic can be found in the [documentation of the Spring framework](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/beans.html).

Next we setup a REST endpoint and parse the NIF input:

```
	@RequestMapping(value = "/e-capitalization", method = RequestMethod.POST)
	public ResponseEntity<String> example(HttpServletRequest request) {

		NIFParameterSet parameters = restHelper.normalizeNif(request, false);
		Model model = restHelper.convertInputToRDFModel(parameters);
```

The first two lines create a REST endpoint `/e-capitalization` that listens on the HTTP POST methods. There is a good tutorial on [Building a RESTful Web Service with Spring MVC](http://spring.io/guides/gs/rest-service/). This is standard Spring MVC.

The next two lines use the RestHelper. This component exposes convenience methods by the FREME framework to make a REST API conform to the [NIF specifications](http://persistence.uni-leipzig.org/nlp2rdf/specification/api.html). For example, in NIF you can submit the data either via the request body or via a parameter in the query string. You can submit the data in plaintext or in various RDF formats. Further some parameters have long forms (e.g.  `input`) and short forms (`i`). The function restHelper.normalizeNIF makes these easier. It extracts all necessary information from the HttpServletRequest and converts it to a NIFParameterSet. The NIFParameterSet provides easy access to all NIF related parameters.

The input data can come in multiple formats restHelper.convertInputToRDFModel converts all these formats to an RDF model. This model uses the [Apache Jena library](https://jena.apache.org/). Using this library you can perform all types of RDF manipulation.

```
		Statement textForEnrichment;
		try {
			textForEnrichment = rdfConversionService
					.extractFirstPlaintext(model);
		} catch (Exception e) {
			logger.error(e);
			throw new InternalServerErrorException();
		}
		if (textForEnrichment == null) {
			throw new BadRequestException("Could not find input for enrichment");
		}
		String plaintext = textForEnrichment.getObject().asLiteral()
				.getString();
```

This piece of code extracts the plaintext for enrichment out of the Jena RDF model. The core is rdfConversionService.extractFirstPlaintext which looks for the first plaintext annotation it can find in the source code and returns a Statement. A Statement is an RDF triple. It catches any exception that occurs in extractFirstPlaintext(). It uses the logger to write the exception in the log file. Then it throws a general InternalServerErrorException(). The exception should not be send to the client directly because it might contain internal information. The InternalServerErrorException formats the exception in a nice way and sets the HTTP status code to 500 (Internal Server Error). In the last line of source code the plaintext is extracted out of the RDF statement.

```
		String enrichment = plaintext.toUpperCase();
		Property property = model
				.createProperty("http://freme-project.eu/example-enrichment");
		textForEnrichment.getSubject().addLiteral(property, enrichment);
```

This code performs the enrichment, creates a new RDF property and adds a new triple to the RDF model.

```
		return restHelper.createSuccessResponse(model,
				parameters.getOutformat());
```

This last line uses restHelper.createSuccessResponse to send the model to the client. Again it supports various RDF serialization formats according to the NIF specification.

# e-capitalization.xml explained

[e-capitalization.xml](https://github.com/freme-project/freme-examples/blob/master/e-capitalization/src/main/resources/spring-configurations/e-capitalization.xml) is the Spring XML configuration that needs to be imported in a FREME package so the FREME package starts the e-Capitalization service. It contains this source code:

```
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans.xsd
	http://www.springframework.org/schema/context
	http://www.springframework.org/schema/context/spring-context.xsd">

	<context:component-scan base-package="eu.freme.eservices.example" />
</beans>
```

Again this is a standard Spring XML configuration file. Unlike in the package.xml here you are allowed to use as many Spring features as you want. But usually these files do not need to contain many information. This example performs a component scan on the package that contains ECapitalizationService.java. By doing so Spring will find all the annotations in ECapitalizationService and do its magic to autowire the beans and setup the REST endpoint.

# ECapitalizationServiceTest.java explained

[ECapitalizationServiceTest.java](https://github.com/freme-project/freme-examples/blob/master/e-capitalization/src/test/java/eu/freme/eservices/example/ECapitalizationServiceTest.java) performs a unit test of e-capitalization. FREME uses [JUnit](http://junit.org/) for testing.

```
	@Test
	public void test() throws UnirestException {
		ApplicationContext context = FREMEStarter
				.startPackageFromClasspath("e-capitalization-test-package.xml");
		TestHelper testHelper = context.getBean(TestHelper.class);

		HttpResponse<String> response = Unirest
				.post(testHelper.getAPIBaseUrl() + "/e-capitalization")
				.queryString("input", "hello world")
				.queryString("informat", "text").asString();

		assertTrue(response.getStatus() == 200);
		assertTrue(response.getBody().contains("HELLO WORLD"));
	}
```

In the first line the test uses FREMEStarter to start the test package. This test package starts a webserver with the e-Capitalization endpoint. Then it gets the TestHelper bean from the application context. The TestHelper provides some convenience methods for unit tests. In this example only TestHelper.getAPIBaseURL() is used which provides the URL of the API - usually  `http://localhost:8080`.

The next lines use the [Unirest](http://unirest.io/java.html) libary to perform an HTTP request to the API. It performs a POST request and sends "hello world" for enrichment. This is plaintext so it also specifies the query string parameter `informat=text`.

The last two lines test if the http status code is 200 and if the response contains "HELLO WORLD" which is the result of the enrichment.

# e-capitalization-test-package.xml explained

[e-capitalization-test-package.xml](https://github.com/freme-project/freme-examples/blob/master/e-capitalization/src/test/resources/e-capitalization-test-package.xml) defines a FREME package for the unit tests.

```
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans.xsd
	http://www.springframework.org/schema/context
	http://www.springframework.org/schema/context/spring-context.xsd">

	<import resource="classpath:spring-configurations/freme-common.xml" />
	<import resource="classpath:spring-configurations/e-capitalization.xml" />
	<import resource="classpath:spring-configurations/test-helper.xml" />

</beans>
```

It defines a FREME package that consists of FREMECommon, e-Capitalization and the test helper. FREMECommon needs to be part of every FREME package. e-Capitalization sets up the API endpoint. The test helper needs to be imported because it is used in the unit tests.
