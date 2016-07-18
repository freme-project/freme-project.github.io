---
title: "Getting Started for System Administrators"
output: html_document
---

To get an overview of the architecture of FREME, have a look at [the freme architecture article](../freme-for-developers/overview-of-the-freme-architecture.html). A short description how FREME is set up and started can be found [here](../freme-for-sysadmins/start-and-run-freme.html).

## Create and run the FREME package

The first thing to you need to do to get started is to create the FREME package 
that you want to use and get it to run. The article [creating and running a FREME package](../freme-for-sysadmins/creating-and-running-a-freme-package.html) describes
all necessary steps to do this and lists the software that needs to be preinstalled on 
your machine.

## Prepare the Database

For using FREME and its services, it is necessary to have access to the FREME database.
The [configuration article](../freme-for-sysadmins/configuration-options.html) explains the different possible configuration options for setting up the database. Some more information about how to initialize the database with FREME's default entries can be found [here](../freme-for-sysadmins/initialising-freme.html).

  
## Starting FREME 

FREME can be started in different ways:

* You can either use **bin/start_local.sh** or **bin/start_server.sh** which is located in the freme-package/bin folder inside the created target folder. Have a look at the [starting FREME article](../freme-for-sysadmins/install-freme-on-server.html) for more information on these files.

* You can run FREME from within your IDE, e.g. Eclipse. How to set up FREME in your IDE is described [here](../freme-for-developers/setup-freme-in-the-ide.html).


## Optional Installation of FREME-NER

FREME-NER provides additional functionality. To get it to run, a few more prerequisites are necessary. You can read more about FREME-NER and its installation in [this article](../freme-for-sysadmins/freme-ner-dummy.html). 
