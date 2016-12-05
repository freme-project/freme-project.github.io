---
layout: page
title: Maintain FREME docker images
dropdown: Knowledge Base, FREME for System Administrators
pos: 4.19
---

# Maintain the FREME docker installation

This guide explains how to maintain the FREME docker images. First it explains the naming of the images. Then it explains how to build images for freme-broker, freme-mysql, freme-solr and freme-virtuoso. In the last chapter the guide explains how to push an image to dockerhub.

## Naming of the images

The docker images in FREME have the following names

* fremeproject/freme-broker
* fremeproject/freme-solr
* fremeproject/freme-mysql-basic
* fremeproject/freme-mysql-standard
* fremeproject/freme-mysql-full

In docker compose the images have other names:

* freme-broker
* freme-solr
* freme-mysql
* freme-virtuoso

## Build the freme-broker image

### 1. Create the FREME package

```
git clone https://github.com/freme-project/freme-packages
cd freme-packages/freme-docker
mvn package
```

The package is now located in directory `target/freme-package`, later in this document referred to as `PATH_TO_PACKAGE`.


### 2. Build the docker image

In a new folder execute these commands

```
# download dockerfile
git clone https://github.com/freme-project/freme-docker
cd freme-docker/freme-broker

# download freme-ner models
mkdir freme-ner-models
cd freme-ner-models
wget http://api.freme-project.eu/datasets/ner-trained-models/wikiner/wikiner-en-ner-model.ser.gz
wget http://api.freme-project.eu/datasets/ner-trained-models/wikiner/wikiner-es-ner-model.ser.gz
wget http://api.freme-project.eu/datasets/ner-trained-models/wikiner/wikiner-fr-ner-model.ser.gz
wget http://api.freme-project.eu/datasets/ner-trained-models/wikiner/wikiner-it-ner-model.ser.gz
wget http://api.freme-project.eu/datasets/ner-trained-models/wikiner/wikiner-nl-ner-model.ser.gz
wget http://api.freme-project.eu/datasets/ner-trained-models/wikiner/wikiner-ru-ner-model.ser.gz
cd ..

# copy freme package
cp -r PATH_TO_FREME_PACKAGE ./

# executing the ls command should show this files and folders:
$ ls
Dockerfile  freme-ner-models  freme-package

# build the image
docker build -t fremeproject/freme-broker .
```

## build freme-solr image

The freme-solr image does not contain any data. The guide [Run FREME in a docker container](use-freme-docker.html) explains how to add data to the Solr server.

```
git clone https://github.com/freme-project/freme-docker
cd freme-docker/freme-solr
docker build -t fremeproject/freme-solr .
```                                                                         

freme-solr extends the [solr:5 docker image](https://hub.docker.com/r/_/solr/). The link contains more documentation on how to use the image.

## build freme-mysql images

FREME has three different images for the MySQL server. They differ in the data that is pre-loaded in the server.

* freme-basic: Contains all XSLT processors, pipelines, SPARQL converters and e-Link templates.
* freme-standard: Contains all data from freme-basic. Further it contains database records for the datasets DBPedia and Europeana for linking in FREME NER. These database records contain only metadata for the datasets, the actual datasets are stored in the Solr and Virtuoso server.
* freme-full: Contains all data from freme-standard but adds datasets for linking in FREME NER. It adds the datasets CORDIS, Geopolitical ontology, Global airports, ONLD, ORCID, VIAF, Grid, GWPP glossary.

To build one of the images (in this case freme-mysql-standard) execute this shell commands:

```
git clone https://github.com/freme-project/freme-docker
cd freme-docker/freme-mysql-standard
docker build -t fremeproject/freme-mysql-standard .
```

The folder contains one or more .sql files. These .sql files contain MySQL dumps that will be loaded into the MySQL server when you build the image. The .sql files will be executed in alphabetical order. The different MySQL docker images do not extend each other. When you edit the sql file to be loaded into freme-basic, then you need to do the same edit in the sql files of freme-standard and freme-full also. Therefore each distribution comes with one .sql file, with names like `0basic.sql`, `1standard.sql` and `2full.sql`. The file `0basic.sql` has the same content in basic, standard and full distribution. The file `1standard.sql` has the same content in standard and full distribution.

All mysql images extend the [mysql:5.7.15 docker image](https://hub.docker.com/r/_/mysql/). The link contains more documentation on how to use the image.

## The virtuoso server

FREME uses the [tenforce/virtuoso image](https://hub.docker.com/r/tenforce/virtuoso/) without modifications. The link contains more information how to use the image.

## Push an image to dockerhub

Here the guide assumes that you have already tested the docker image and verified that it works. Further the guide assumes that you have an account on dockerhub.com[http://dockerhub.com] with write access to the [freme dockerhub repository](https://hub.docker.com/u/fremeproject/dashboard/). You should have performed the [docker login](https://docs.docker.com/engine/reference/commandline/login/) command.

Execute this shell command to push the freme-broker image to dockerhub.

```
docker push fremeproject/freme-broker
```

## Run the containers without docker compose

To run the docker containers without docker compose use these commands:

### freme-mysql-standard

This works for freme-mysql-basic and freme-mysql-full as well.

```
docker run -e MYSQL_ROOT_PASSWORD=root -d fremeproject/freme-mysql-standard
```

### virtuoso

```
docker run -e DBA_PASSWORD=myDbaPassword -e SPARQL_UPDATE=true -e DEFAULT_GRAPH=http://www.example.com/my-graph -v /my/path/to/the/virtuoso/db:/data -d tenforce/virtuoso
```

### solr

```
docker run --name freme-solr -d-p 4002:8983 fremeproject/freme-solr
```

### freme-broker

You need to setup the network connection from the broker to the other VMs using `--link` option. 

```
docker run -d --link freme-mysql:mysql --link freme-solr:solr --link freme-virtuoso -p 4000:8080 fremeproject/freme-broker
```

