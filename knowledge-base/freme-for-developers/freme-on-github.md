---
layout: page
title: FREME on Github
dropdown: Knowledge Base, FREME for Developers
pos: 4.7
---

**Freme on Github**
------------------

This article explains the different FREME repositories on GitHub. FREME maintains an organisation on GitHub. The main page of this organisation is [https://github.com/freme-project](https://github.com/freme-project). Furthermore, have a look at the [Overview of the FREME Architecture](http://api.freme-project.eu/doc/current/knowledge-base/freme-for-developers/overview-of-the-freme-architecture.html).

[technical-discussion](https://github.com/freme-project/technical-discussion)
---------------------
This Repository is our meta repository for technical discussion and documentation. It does not contain any source codes. We use it for

 * General technical discussion
 * Specification of general features
 * Wiki for documentation and knowledge base

[e-Services](https://github.com/freme-project/e-services)
------------
This repository holds the code for the [FREME e-Services](../freme-for-sysadmins/e-services.html).

[FREME NER](https://github.com/freme-project/freme-ner)
-----------
Holds codes and implementation task issues for [FREME Named Entity Recognizer](../freme-for-api-users/freme-ner.html).

[Basic-Services](https://github.com/freme-project/basic-services)
----------------
This repository holds the code for the [FREME Basic-Services](../freme-for-sysadmins/basic-services.html).

[FREME common](https://github.com/freme-project/FREMECommon)
--------------
Holds codes commonly used across multiple FREME repositories.

[FREME parent](https://github.com/freme-project/freme-parent)
--------------
This repository holds the code of FREME parent. It contains just a pom.xml which defines some general defaults for all FREME projects:

 * [Spring Boot](http://projects.spring.io/spring-boot/) and [Jena](https://jena.apache.org/tutorials/sparql.html) versions
 * Java compiler version
 * Versions of FREMECommon, FREME Basic-Services and FREME e-Services
 * FREME repository locations
 * FREME distribution management

[FREME packages](https://github.com/freme-project/freme-packages)
----------------
This repository holds runnable packages of FREME, see [FREME packages](../freme-for-sysadmins/freme-packages.html).

[freme-project.github.io](https://github.com/freme-project/freme-project.github.io)
------------
This repository holds the code for the [FREME documentation](../..). Have a look at [How to write a tutorial]({{site.basePath | prepend: site.github.url }}/tutorials/how-to-write-tutorials.html) and [Maintaining the Documentation Project](http://api.freme-project.eu/doc/current/knowledge-base/freme-for-developers/maintaining-the-documentation-project.html) if you intend to contribute to the FREME documentation.

[FREME Examples](https://github.com/freme-project/freme-examples)
------------
This repository contains code which explains parts of the [FREME architecture](../freme-for-developers/overview-of-the-freme-architecture.html):

 * [diary](https://github.com/freme-project/freme-examples/tree/master/diary) shows the usage of database resources with access restrictions, see the article [Implementing Restricted Access for Database Resources](../freme-for-developers/implementing-restricted-access-to-database-resources.html) and the [authentication article](../freme-for-api-users/authentication.html) for further information.
 * [logging-filter](https://github.com/freme-project/freme-examples/tree/master/logging-filter) explains the creation of a simple [basic-service](../freme-for-sysadmins/basic-services.html), see [Creating a Basic Service](../freme-for-developers/creating-a-basic-service.html).
 * [e-capitalization](https://github.com/freme-project/freme-examples/tree/master/e-capitalization) explains the creation of a simple [e-service](../freme-for-sysadmins/e-services.html), see [How to write an e-Service](../freme-for-developers/how-to-write-an-eservice.html) and [Create a new e-Service]({{site.basePath | prepend: site.github.url }}/tutorials/implement-eservice.html).
 * [broker-simple](https://github.com/freme-project/freme-examples/tree/master/broker-simple) gives an example for a simple [FREME package](../freme-for-sysadmins/freme-packages.html), see [Creating and Running a FREME Package](../freme-for-sysadmins/creating-and-running-a-freme-package.html).

Depricated Repositories
-----------------------

### [Broker](https://github.com/freme-project/Broker)
This repository is deprecated. It has moved to the [freme-packages](https://github.com/freme-project/freme-packages) repository. It is used only to keep old issues.

### [e-Entity](https://github.com/freme-project/e-Entity)
This repository is deprecated. It has moved to [e-services](https://github.com/freme-project/e-services) repository. It is used only to keep old issues.
	
### [e-Link](https://github.com/freme-project/e-Link)
This repository is deprecated. It has moved to [e-services](https://github.com/freme-project/e-services) repository. It is used only to keep old issues.


### [e-Publishing](https://github.com/freme-project/e-Publishing)
This repository is deprecated. It has moved to [e-services](https://github.com/freme-project/basic-services) repository. It is used only to keep old issues.

### [e-Internationalization](https://github.com/freme-project/e-Internationalization)
This repository is deprecated. It has moved to [e-services](https://github.com/freme-project/basic-services) repository, see `/internalization`. It is used only to keep old issues.

[pipelines](https://github.com/freme-project/pipelines)
-----------
This repository is deprecated. It has moved to [e-services](https://github.com/freme-project/basic-services) repository, see `/controllers/pipelines`. It is used only to keep old issues.
