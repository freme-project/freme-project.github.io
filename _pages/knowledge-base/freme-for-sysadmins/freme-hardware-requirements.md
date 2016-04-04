---
layout: page
title: FREME hardware requirements
dropdown: Knowledge Base, FREME for System Administrators
pos: 4.17
---
# FREME hardware requirements

The following pages explain the hardware requirements of FREME NER. They are intended to assist system administrators who want to setup a FREME installation on their own server.

This guide distinguishes between FREME broker and FREME NER because FREME NER is by far the most resource intensive part of FREME. It is possible to either run both systems on the same server or to setup the broker on one server and FREME NER on another server.

## FREME broker

The FREME broker does not require so many hardware resources. The hardware requirements grow with the amount of users that use the system. In order to allow 1000 API requests per hour, we recommend to allocate this hardware for FREME: 2 CPU cores, 4 GB of RAM, 2 GB of Hard Disk.

## FREME NER

We recommend using 20 GB of RAM, 4 CPU cores and 100 GB of disk space. The following considerations apply to the RAM usage of FREME NER:

* The language models that FREME NER uses are loaded in the RAM. Each of these models uses 1-1.5 GB of RAM. it makes sense to configure FREME NER to use only required languages to save RAM.
* The other factor that uses a log of RAM is the Apache Solr Server. The more RAM the Solr Server can use for caching the better its performance will be.
* The rest of FREME NER requires around 1 GB of RAM.
