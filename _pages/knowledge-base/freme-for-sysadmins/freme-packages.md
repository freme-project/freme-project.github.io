---
layout: page
title: FREME Packages
dropdown: Knowledge Base, FREME for System Administrators
pos: 4.14
---

# FREME Packages

A FREME package represents an executable collection of [e-Services](../freme-for-sysadmins/e-services.html) and [Basic-Services](../freme-for-sysadmins/basic-services.html). This article lists the packages predefined by FREME. You can simply get them by cloning the [freme-packages repository](https://github.com/freme-project/freme-packages): `git clone https://github.com/freme-project/freme-packages`.

If you are interested in setting up your own FREME package, see [Creating and Running a FREME Package](../freme-for-sysadmins/creating-and-running-a-freme-package.html), which also describes how to start a FREME package.

**Note**: To get a list of the services loaded in a certain package have a look at its `package.xml` file located in `freme-packages/PACKAGE-NAME/src/main/resources/`.

## broker-local

For local development we advise to use the package broker-local which is configured for usage in a local computer. It contains a complete configuration, meaning that the configuration works out of the box. The e-Services Tilde e-Translation, Tilde e-Terminology, e-Link, DBPedia Spotlight and e-Publishing are part of the package. FREME NER is not included in the configuration. It uses the H2 in-memory database which means that it does not persist when FREME stops.

## freme-full

The freme-full package contains all available [e-Services](../freme-for-sysadmins/e-services.html) and [Basic-Services](../freme-for-sysadmins/basic-services.html) except the rate-limiting filter. It is predefined to use a MySQL database, but the related properties have to be adjusted in the `application.properties` file. See the article [FREME Configuration Options](..//freme-for-sysadmins/configuration-options.html) if you need more information how to do so. Furthermore, the freme-full package includes FREME-NER. The article [FREME NER](../freme-for-api-users/freme-ner.html) describes this e-Service and its prerequisites in detail.
 
## broker-dev

The broker-dev package is similar to the freme-full package, except that it does not include FREME-NER itself, but proxies this e-Service to another location. This package is deployed in the official FREME setting.

## freme-ner-dev

The freme-ner-dev package just contains the [internalization](../freme-for-api-users/eInternationalisation.html) filter and [FREME-NER](../freme-for-api-users/freme-ner.html) to outsource this resource-intensive application. This package is deployed in the official FREME setting. 