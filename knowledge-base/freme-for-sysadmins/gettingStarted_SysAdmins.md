---
layout: page
title: Getting started for System Administrators
dropdown: Knowledge Base, FREME for System Administrators
pos: 4.19
---

# Getting started for System Administrators

To get an overview of the architecture of FREME, have a look at [the freme architecture article](../freme-for-developers/overview-of-the-freme-architecture.html). A short description how FREME is set up and started can be found [here](../freme-for-sysadmins/start-and-run-freme.html).

## Create and run the FREME package

The first thing you need to do to get started is to create the FREME package that you want to use and get it to run. The article [creating and running a FREME package](../freme-for-sysadmins/creating-and-running-a-freme-package.html) describes all necessary steps to do this and lists the software that needs to be preinstalled on your machine. To get more information about the freme-packages, have a look at the [FREME package article](../freme-for-sysadmins/freme-packages.html).

## Prepare the Database

For using FREME and its services, it is necessary to have access to the FREME database.
The [configuration article](../freme-for-sysadmins/configuration-options.html) explains the different possible configuration options for setting up the database. Some more information about how to initialize the database with FREME's default entries can be found [here](../freme-for-sysadmins/initialising-freme.html).

  
## Starting FREME 

FREME can be started in different ways:

* You can either use **bin/start_local.sh** or **bin/start_server.sh** which is located in the freme-package/bin folder inside the created target folder. Have a look at the [starting FREME article](../freme-for-sysadmins/start-and-run-freme.html) for more information on these files.

* You can run FREME from within your IDE, e.g. Eclipse. How to set up FREME in your IDE is described [here](../freme-for-developers/setup-freme-in-the-ide.html).


## Optional Installation of FREME-NER

FREME-NER provides additional functionality. To get it to run, a few more prerequisites are necessary. You can read more about FREME-NER and its installation in [this article](../freme-for-sysadmins/freme-ner-dummy.html). 


## Verifying if installation was succesful

To verify that FREME works after an installation you can run the tests in a test suite created with the automated test 
feature of postman. When you run the test suite a series of postman requests is executed. The HTTP response of the 
requests will be matched against a set of rules.


To execute the test suite

* Download the [collection](https://raw.githubusercontent.com/freme-project/freme-project.github.io/dev/resources/postman/FREME-TEST.postman_collection.json)
* Import it into Postman and create an environment with a variable "baseUrl" that points to the API you want to test 
(more information on this can be found [here](../freme-for-api-users/gettingStarted_API-users.html)).
* Press "Runner" (upper left corner of the screen)
* Select collection "FREME TEST" and your newly created environment
* Run the tests by pressing "Start Test"

Currently it does not write any data. It performs API calls from the Postman collection and checks if the response code is 200.
It runs these tests for

- e-Translation
- freme-ner 
- freme-ner using e-internationalization (html roundtripping and html to nif)
- e-Terminology
- e-link
- get all datasets
- get all templates
- filter - knowledgebase example
- get all filter
- get all pipelines
- nif-converter xml
- get all users
- tei2temp-html
- get all xslt-converters
