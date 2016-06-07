---
layout: page
title: Creating a Basic Service
dropdown: Knowledge Base, FREME for Developers
pos: 4.6
---

# Creating a Basic Service

This article explains how to create a FREME basic service. It will create a filter that is executed before every API request. The filter writes a message to the logger for every API request. You can find the whole source code in the logging-filter project in the [freme-example GitHub repository](https://github.com/freme-project/freme-examples).

# Table of Contents

* [Components of a basic service](#components-of-a-basic-service)
    * [pom.xml explained](#pomxml-explained)
    * [Source code explained](#source-code-explained)
    * [Spring XML configuration](#spring-xml-configuration)
* [Testing the filter](#testing-the-filter)

# Components of a basic service

Every basic service consists at least of a pom.xml to provide the maven configuration, a Java source code file that implements the service and a Spring XML configuration file to load the basic service. This section explains these three components in the example.

## pom.xml explained

[pom.xml](https://github.com/freme-project/freme-examples/blob/master/logging-filter/pom.xml) is an [Apache Maven](https://maven.apache.org/) configuration file that mainly pulls in the required dependencies. Like every basic service it inherits from the artifact eu.freme.bservices.basic-services-parent. This simplifies the Maven setup of basic services a lot because all common configuration can be done in the parent artifact. Further it defines a dependency on the test-helper artifact because this will be needed later on in this tutorial.

## Source code explained

[ExampleLoggingFilter.java](https://github.com/freme-project/freme-examples/blob/master/logging-filter/src/main/java/eu/freme/bservices/example/loggingfilter/ExampleLoggingFilter.java) contains the source codes of the example logging filter. Here is the source code:

```
@Component
public class ExampleLoggingFilter extends GenericFilterBean {

	Logger logger = Logger.getLogger(ExampleLoggingFilter.class);

	@Override
	public void doFilter(ServletRequest req, ServletResponse res,
			FilterChain chain) throws IOException, ServletException {

		if (req instanceof HttpServletRequest) {
			HttpServletRequest httpRequest = (HttpServletRequest) req;
			String uri = httpRequest.getRequestURI();
			logger.info("Detect HTTP request to endpoint " + uri);
		}

		chain.doFilter(req, res);
	}
}
```

ExampleLoggingFilter is implemented as a standard filter in the Spring MVC framework. Therefore it extends GenericFilterBean and is defined as a Spring Bean by the `@Component` annotation. Then it creates the logger. FREME uses [Apache Log4j](http://logging.apache.org/log4j/2.x/) framework for logging.

Every Spring MVC filter overrides the method doFilter. It is executed upon every HTTP request, before the request is processed by the controller. It contains only a short source code that converts the request to an HttpServletRequest and logs the URI to the logger. Then it calls chain.doFilter() which is required by the Spring MVC framework so the request is passed to the next filter in the filter chain.

### Using custom serialization formats in controllers and filters

If you want to implement an HTTP API endpoint which has to accept any HTTP mime types or informat and outformat values different from the [serialization formats defined in FREMECommon](https://github.com/freme-project/FREMECommon/blob/master/src/main/java/eu/freme/common/conversion/SerializationFormatMapper.java#L26-L49)(plaintext, json, rdf types), you have to register them in the SerializationFormatMapper. Otherwise the internalization filter will complain about an unknown input or output format. This can be done easily like the following example illustrates:

```
// autowire the SerializationFormatMapper
@Autowired
SerializationFormatMapper serializationFormatMapper;

// do the registration by adding the format to the SerializationFormatMapper in your PostConstruct function
@PostConstruct
public void init(){
     // This is the mandatory registration
     serializationFormatMapper.put("multipart/form-data", "multipart/form-data");
     // optional: mapping of a hand-defined type to the correct MimeType. If it is not an existing mimeType, this works just for the parameter "input"
     serializationFormatMapper.put("zip", "multipart/form-data");
 }
```

The code above exemplary registers the mime type `multipart/form-data` and in addition the short form `zip` which should be available as value for the `informat` or `outformat` parameter.
Furthermore, the `serializationFormatMapper` is intended to do the normalization of these values:

```
// autowire the SerializationFormatMapper
@Autowired
SerializationFormatMapper serializationFormatMapper;

// defining a HTTP endpoint with Spring MVC
@RequestMapping(value = "/exampleEndpoint", method = RequestMethod.POST)
public ResponseEntity<String> doSomething(
            @RequestHeader(value = "Accept", required = false) String acceptHeader,
            @RequestHeader(value = "Content-Type", required = false) String contentTypeHeader,
            @RequestParam(value = informat, required = false) String informat,
            @RequestParam(value = outformat, required = false) String outformat,
            @RequestBody (required = false) String postBody)
{
    //// normalize and merge the format values
    informat = serializationFormatMapper.get(informat);
    if(informat == null){
       informat = serializationFormatMapper.get(contentTypeHeader);
    }
    outformat = serializationFormatMapper.get(outformat);
    if(outformat == null){
      outformat = serializationFormatMapper.get(acceptHeader);
    }
    ////

    //// use informat & outformat
    // ...
    ////
}
```

## Spring XML configuration

The Spring XML configuration is provided by the file [example-logger.xml](https://github.com/freme-project/freme-examples/blob/master/logging-filter/src/main/resources/spring-configurations/example-logger.xml). As all Spring configurations it resides in the resource folder "spring-configurations". It instructs the Spring application context to perform a component scan on the package `eu.freme.bservices.example.loggingfilter`. Through this configuration Spring will find the Bean defined by ExampleLoggingFilter.java and initialize the filter.

# Testing the filter

Now we have an implementation of the filter that is ready for inclusion into any FREME package. This section of the article shows how to write a simple FREME package to start the filter. Please have a look at [Creating and Running a FREME Package](../../freme-for-sysadmins/creating-and-running-a-freme-package.html) if you want to dig deeper into this. The files described here are not necessarily part of a FREME basic service. They are contained in the example only for demonstration purposes.

[package.xml](https://github.com/freme-project/freme-examples/blob/master/logging-filter/src/main/resources/package.xml) defines a very simple FREME package. First like all FREME packages it loads `freme-common.xml`. Then it loads `test-helper.xml`. Further the package imports `example-logger.xml` to initialize the logging filter created in this guide.

```
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans.xsd
	http://www.springframework.org/schema/context
	http://www.springframework.org/schema/context/spring-context.xsd">

	<import resource="classpath:spring-configurations/freme-common.xml" />
	<import resource="classpath:spring-configurations/test-helper.xml" />
	<import resource="classpath:spring-configurations/example-logger.xml" />

</beans>
```

From within your IDE you can now run the main class `eu.freme.common.starter.FREMEStarter`. This starter class looks for a file called `package.xml` located in the root of the Java class path. So it will start the package.xml file described above.

The test-helper basic service creates an REST endpoint on `/mockups/file`. When FREME is started you can call the REST endpoint by opening `http://localhost:8080/mockups/file/http-response.txt` with a web browser. The mockup endpoint returns the file [http-response.txt](https://github.com/freme-project/freme-examples/blob/master/logging-filter/src/main/resources/mockup-endpoint-data/http-response.txt). So it sends "hello world" to the web browser. Usually this functionality is used to create mockup endpoints for unit testing but here we use it so we can create an API endpoint without programming.

Now you can take a look at the console output of FREME. In the log stream you can find the message
```
ExampleLoggingFilter: Detect HTTP request to URI /mockups/file/http-response.txt
```
This message was generated by the example logging filter.