---
layout: page
title: Getting started with FREME development
dropdown: Knowledge Base, FREME for Developers
pos: 4.1
---
# Getting started with FREME development

This guide walks you through setting up a FREME package for local development. It covers downloading the source codes of the broker from GitHub and starting FREME the first time. Then it explains how to setup the project in the Eclipse IDE and how to do implementation work on an e-Service.

## Pre-requisites

This tutorial assumes that you are using a Linux or Mac environment. You can also perform the steps in a Windows environment but then the shell commans are different. It further assumes that the following software is installed:

* Java (Version 8 or higher)
* Apache Maven
* Git
* [Eclipse IDE for Java EE Developers](https://www.eclipse.org/downloads/). This particular distribution is suggested because it supports Maven and Git out of the box. Other IDEs can be used also but this tutorial assumes the Eclipse IDE.

## Download FREME package

A freme package is a set of configuration files that determine a set of FREME basic services and e-Services that are started together in one Java application. Further it contains configuration files that configure this application. The [freme-packages](https://github.com/freme-project/freme-packages) repository on GitHub lists a set of different FREME packages. Some distributions are configured to run on a webserver, e.g. [broker-dev](https://github.com/freme-project/freme-packages/tree/master/broker-dev). The configuration of these packages on GitHub is not complete because it contains confidential information like database passwords. 

For local development we advise to use the package [broker-local](https://github.com/freme-project/freme-packages/tree/master/broker-local) which is configured for usage in a local computer. It contains a complete configuration, meaning that the configuration works out of the box. The e-Services Tilde e-Translation, Tilde e-Terminology, e-Link, DBPedia Spotlight and e-Publishing are part of the package. FREME NER is not included in the configuration. It uses the H2 in-memory database which means that it does not persist when FREME stops.

First you download the package and compile it the first time:

```
git clone https://github.com/freme-project/freme-packages
cd freme-packages/broker-local
mvn install 
```

## Start FREME from the command line

You can use Maven to create a runnable distribution out of FREME. The distribution consists of a Jar file, start scripts and configuration files. To create the distribution and start FREME execute these shell commands:

```
mvn package
cd target/freme-package
chmod +x bin/start_local.sh
bin/start_local.sh
```

FREME will start up. It is ready to use when the console output stops changing and you see the message "Started FREMEStarter in xy seconds".

Now you can perform your first request to FREME. Open another shell and execute

```
curl -X POST -H "Content-Type: text/plain" -H "Accept: text/turtle"  -d 'Hello World' "http://localhost:8080/e-translation/tilde?source-lang=en&target-lang=de"
```

This sends an HTTP request to your local FREME instance, requesting to translate the string "Hello World" from English to German. 

## Setup FREME in IDE

Next you setup the project in the IDE. In this example we use the Eclipse IDE. Run this Maven command to create an Eclipse project:

```
mvn eclipse:eclipse
```

Then startup eclipse and select any workspace. In Eclipse, press File -> Import -> Existing Projects into Workspace and select the folder "broker-local".

Next start FREME from within the IDE. In Eclipse, press Run -> Run Configurations -> double click on "Java Application". Specify Name "broker-local" and Main-Class "eu.freme.common.starter.FREMEStarter". Then press "Run". Now FREME will run from within your IDE.

## Develop an e-Service

This section guides you through downloading the source code of the e-Translation service, setting it up in the IDE and start FREME with your modified source code from within the IDE.

First download the source code and create an eclipse project:

```
git clone https://github.com/freme-project/e-services
cd e-services/tilde-services
mvn eclipse:eclipse
```

Then import the project in eclipse. In Eclipse, press File -> Import -> General -> Existing Projects into Workspace and select the folder "tilde-services".

Now you can edit the source code of e-Translation. For example you can open the file "src/main/java/eu/freme/eservices/tilde/translation/TildeETranslation.java". In line 117, enter "plaintext = plaintext.toUpperCase();". This will transform any string to upper case letters before it is send to the external Tilde service.

Now start FREME from the IDE using the run configuration for the broker-local project you created in the previous step of this tutorial. The package will start with the modified version of e-Translation.





