---
layout: page
title: Starting FREME
dropdown: Knowledge Base
pos: 4.1
---


# Start FREME

Starting FREME is as easy as downloading the FREME distribution and executing a shell script. This guide explains how to start FREME either on your own server or on your own local computer.

## Download FREME distribution

You can download the distribution from http://api-dev.freme-project.eu/freme-distributions. In that link you can find several versions of FREME. There are snapshot versions that have SNAPSHOT in the filename. These versions contains the latest development version and is unstable and untested. All files that do not contain SNAPSHOT in the name are release versions. We advise to download the latest release version.

## Start FREME

We assume that you have already downloaded FREME and extracted the zip file to a folder. You can start FREME with different profiles. Each profile defines a set of functions that FREME starts. The profiles are also used to deploy FREME in the cloud with a different set of functionality on different servers. The different profiles are

## broker Profile

Start the "broker" profile in order to start FREME with all endpoints, user management, and security features. The "broker" profile does not start FREME Named Entity Recognition. You can start the broker profile by running on the command line:

``` 
java -jar FREME*.jar eu.freme.broker.Broker
``` 

## fremener Profile

The "fremener" profiles starts FREME only with the API endpoints for FREME Named Entity Recognition. It does not start security features.  You can start the fremener profile by running on the command line: 

``` 
java -jar FREME*.jar eu.freme.broker.FremeNERStarter
```

FREME NER requires an installation of Apache Solr. Please add the URL of the Solr instance to your "application-fremener.properties" configuration file.

# Configuration

FREME is configured via Java properties files. You can see an overview over the configuration options in [FREME configuration options](configuration-options.html). This page does not cover individual configuration options but the location of the configuration files.

All configuration is located in the folder "config". There is a file "application.properties" which contains general configuration that is used across all profiles. There is also profile specific configuration in "application-broker.properties" and "application-fremener.properties".
