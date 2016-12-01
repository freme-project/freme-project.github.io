---
layout: page
title: Install FREME using docker
dropdown: Knowledge Base, FREME for System Administrators
pos: 4.18
---

# Run FREME in a docker container

This article describes how to run FREME in docker.

## Overview

FREME uses [Docker Compose](https://docs.docker.com/compose/) to hide the individual docker images that a FREME installation consists of from the user and to make it easier for users to install the multiple images together. You will install four different virtual machines in this guide. One runs the broker, one runs a Solr server, one runs a Virtuoso server and the forth a MySQL server. But you do not have to care about the individual virtual machines because the single docker-compose file orchestrates all virtual machines together.

FREME comes in three different distributions. All FREME distributions contain all e-Services, all basic services and all FREME NER language models. They differ in the amount of pre-initialized data:

* basic: Initializes XSLT processors, pipelines, SPARQL converters, e-Link templates. These are all stored in a MySQL database. The image requires 7 GB of disk space. This installation allows FREME NER in modes spot and classify only because it does not contain any datasets for linking.
* standard: Contains all data of the basic installation. Further it contians DBPedia datasets in 7 languages (English, German, Dutch, French, Italian, Spanish, Russian) and the Europeana datasets. The size of this is about 22 GB of disk space. It adds the linking functionality to FREME NER for DBPedia in all languages and Europeana dataset.
* full: It contains all data of the standard installation. Further it contains CORDIS, Geopolitical ontology, Global airports, ONLD, ORCID, VIAF, Grid, GWPP glossary. It adds the linking functionality to FREME NER for all datasets.

## Install FREME from docker

This guide assumes that you want to install freme on a linux server. It is possible to run docker on other operating systems also but this guide support linux servers only.

### 1. Install pre-requisites

* Install docker ([installation instructions](https://docs.docker.com/engine/installation/linux/))
* Install docker-compose ([installation instructions](https://docs.docker.com/compose/install/))

### 2. Initialize docker-compose 

#### Create  folders:

```
mkdir /opt/freme /opt/freme-data
chmod -R o+rw /opt/freme-data
```

#### Download docker-compose files

```
cd /opt/freme
wget https://raw.githubusercontent.com/freme-project/freme-docker/master/compose/docker-compose.yml
wget https://raw.githubusercontent.com/freme-project/freme-docker/master/compose/config.env
```

#### Configure environment variable

The FREME distribution is configured in the environment variable `FREME_DISTRIBUTION`. Possible values are `basic`, `standard` or `full`. To configure the standard distribution please execute

```
export FREME_DISTRIBUTION=standard
```

To configure this variable permanently so it is still available after a reboot you can add it to .profile:

```
echo "export FREME_DISTRIBUTION=standard" >> ~/.profile
```

#### Add configuration options

Please set configuration options in /opt/freme/config.env . There you can set the passwords for mysql root user, freme admin user, virtuoso dba user and the languages for FREME NER. Example configuration:

```
# root password for mysql server. Please configure the same password twice in the parameters MYSQL_ROOT_PASSWORD and SPRING_DATASOURCe_PASSWORD
MYSQL_ROOT_PASSWORD=password
SPRING_DATASOURCE_PASSWORD=password

# password for freme root user
ADMIN_PASSWORD=password

# load these models into freme-ner (csv list). This has significant influence on the RAM consumption, each languages requires between 1 and 2 GB. 
FREME_NER_LANGUAGES=en,de,ru

# password for virtuoso root user
DBA_PASSWORD=dba

# You can define JVM options, like memory settings, for the broker here.
JAVA_OPTS=-Xmx10g
```

About the memory configuration: You can calculate the memory consumption of the FREME broker as follows:

* FREME itself requires 2 GB of FRAM
* Each FREME NER language model requires 1 GB of RAM, the russian language model requires 1.5 GB of RAM.

So a FREME installation with all 7 languages requires the option `-Xmx9500m`.

In this file you can also set other FREME configuration options. This is not necessary in this guide but it might be necessary for future configuration. See [configuration of FREME]([FREME configuration options](https://freme-project.github.io/knowledge-base/freme-for-sysadmins/configuration-options.html) for a list of options. The FREME configuration options set in this way are environenment variables so the variable names differ from the standard configuration options. See [External configuration, relaxed bindings](http://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-external-config.html#boot-features-external-config-relaxed-binding) for more details.  

### 3. Add data for standard / full distribution

This is only necessary in the standard or full distribution. This steps downloads a fle data for standard or full distribution and unpacks it to the data folder. The example shows freme-standard data file because currently the freme-full data file is not available:

``` 
wget http://rv1443.1blu.de/docker/freme-standard.tar.gz
tar -xzf freme-standard.tar.gz -C /opt/freme-data
rm freme-standard.tar.gz
```

### 4. Start docker-compose

The first time you run this command it will download several gigabyte of data.

```
cd /opt/freme
docker-compose up -d
```

Logfiles will be written to `/opt/freme-data/logs`.

4. Try if the installation has worked

FREME listens on the host machine on port 4000. You can try an API request:

```
curl -X POST "http://localhost:4000/e-translation/tilde?input=hello+world&informat=text&source-lang=en&target-lang=de"
```

The installation is finished. Please note that the Solr server needs several minutes for initialisation. API requests to FREME NER that use the Solr server will fail when Solr is initialising.

## Useful docker commands

### Stop FREME

Open a shell in the folder that contains the docker-compose.yml file. Then execute

```
cd /opt/freme
docker-compose stop
```

This section provides useful commands. It is not necessary to execute these commands during the installation.

### Update an image

This is important when the image for e.g. freme-broker has changed and you want to use the latest version of the image.

```
docker pull fremeproject/freme-broker
docker-compose stop freme-broker
docker-compose up -d --no-deps freme-broker
```

### Restart a specific service

```
docker-compose stop freme-broker
docker-compose start freme-broker
```
