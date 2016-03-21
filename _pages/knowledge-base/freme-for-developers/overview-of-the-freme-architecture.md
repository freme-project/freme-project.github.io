---
layout: page
title: Overview of the FREME Architecture
dropdown: Knowledge Base, FREME for Developers
pos: 4.11
---

# Overview of the FREME Architecture

## Design goals

The FREME architecture provides a framework to create natural language processing (NLP) applications that

* expose their services through REST APIs.
* use the Natural Language Interchange Format (NIF) as input / output format.
* are implemented in Java.

The framework was designed to fulfill these goals:

* Decoupling and high modularity of its components
* Reusability of the components
* Easy integration of new services through re-use of components
* Interoperability of the services through NIF

## Elements of the architecture

This image shows the three layer architecture of FREME:

<figure>
  <img src="../../img/freme-architecture.PNG" width=795/>
</figure>

**Basic services** form the bottom layer. There is FREMECommon which provides common codes that form the basis of all FREME applications. Examples for their functionality are

* Provide a common persistence layer
* Provide helper functions to read and write NIF
* Provide helper functions to start a web server and REST endpoints

### Optional basic services

In the bottom layer next to FREMECommon are the optional basic services. These basic services provide functionality that are useful for such applications. They can be optionally included in any application that uses FREME. Example of basic services are

* e-Internationalization service that offers additional input and output formats for FREME.
* CORS service that enables Cross Origin Resource Sharing on the API endpoints.
* Rate Limiter that allows to control the amount of API calls each user can perform.

### e-Services

The next layer consists of e-Services. These e-Services expose certain NLP service via a REST API. They have a modular design also and can be included in any application using FREME. Examples of e-Services are

* Tilde e-Translation provides a bridge to Tilde Lets MT API.
* FREME NER provides named entity spotting, classification and recognition using FREME NER

The difference between e-Services and basic services is that e-Services provide NLP functionality. They have characteristics like starting an REST API endpoint and using NIF as input / output format. Basic services provide all functionalities other then enrichment.

During the course of the FREME project a set of e-Services has been created. Other projects using the FREME architecture can also contribute e-Services as well. These e-Services can be combined at will in applications that build on FREME.

### FREME packages

FREME packages form the top layer of the architecture. When above text spoke about applications building on the FREME framework it actually means FREME packages. A FREME package is a set of basic services and e-Services. It consists of configuration files only that define the set of services and provide configuration for the e-Services. The package also provides a workflow to start the package and deploy it on a web server.
