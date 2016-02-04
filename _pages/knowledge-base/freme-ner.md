---
layout: page
title: FREME NER technology stack
dropdown: Knowledge Base
pos: 4.1
---


# FREME NER Overview

FREME NER is a named entity recognition tool. It performs entity spotting - spot entity mentions in free texts, entity classification - assigning types from a given knowledge base, entity linking - linking entity mentions with their instances in a given dataset. FREME NER aims at providing support for large variety of languages. Currently, it can perform named entity recognition over texts written in English, German, Dutch, Spanish, Italian, French and Russian.

## Technology stack

The FREME NER builds on top of mature technologies and appropriately extends them. Following figure illustrates the technology stack. 

<figure>
  <img src="https://docs.google.com/drawings/d/1rBUpgRBlhh0We01PNOpKeCFVaoUEDi9sAah8E28r6WY/pub?w=378&amp;h=401" /> 
</figure>

#### Entity spotting

Entity spotting is performed based on a Conditional Random Field (CRF) sequence models learned on a large scale training data. As reference implmentation for CRF is used StanfordNER and models for each supported language has been compiled.

#### Entity classification

Entity classification is supported via 1) external knowledge bases with entity types (e.g., the DBpedia instance types partition), and 2) using CRF classification models trained on large scale labeled data. The CRF models currently are trained on data with four entity types: Person (PER), Location (LOC), Organization (ORG) and Miscellaneous (MISC). The entity types from the external knowledge bases are dependent on the source data and usually these types are more precise and fine-grained. For instance, the DBpedia 2015 ontology encompasses 735 ontology classes (entity types).

#### Entity linking

FREME NER performs linking of the spotted entity mentions with their representation in a specified knowledge base. Currently, FREME NER integrates several datasets for entity linking including DBpedia, VIAF, CORDIS FP7, ORCID, ONLD, Geopolitical Ontology, and the Global airports dataset. A user using the ```dataset``` parameter can specify the dataset to be used for entity linking.
The current entity linking approach is relying on a most-frequent-sense method, where the entity is linked with the most common entity for the list of candidate entities. The current implementation is using Apache Solr for the candidate generation.

## Core Features

#### Domain specific NER
FREME NER exlusively provides domain specific adoption. A user using the ```domain``` parameter can specify the domain of interest and only entities from that domain will be returned. FREME NER is using TaaS as domain classification system and it supports following domains: TaaS-2007 Sports, TaaS-1510 Tourism, TaaS-0303 Finance and accounting, TaaS-0200 Law, TaaS-0305 Marketing and public relations, TaaS-2303 Literature, TaaS-0100 Politics and Administration, TaaS-0300 Economics, TaaS-1000 Agriculture and foodstuff, TaaS-1005 Foodstuff, TaaS-2000 Social sciences, TaaS-2001 Education, TaaS-2002 History, TaaS-2005 Culture and religion, TaaS-2006 Linguistics, TaaS-2300 Arts, TaaS-2302 Music, TaaS-2304 Dance, TaaS-1500 Industries and technology, TaaS-1502 Chemical industry, TaaS-1509 Transportation and aeronautics, and TaaS-2200 Medicine and pharmacy.

#### Dataset specific NER and datasets management
Proprietary datasets can be easily integrated in FREME NER and further used for entity linking. Thus, FREME NER provides dataset management API. A user can upload his/her dataset and then perform entity linking using this dataset. This allows users to integrate custom datsets.

#### Entity filtering
While in some cases a user is interested in recognition of all the entities, in some cases a user would like to spot entities only of a specific types. Only organizations, or project names. For this purpose, FREME NER implements an entity filtering feature using the ```types``` parameter. A user can submit his/her content and specify the list of entity types that are of his interest. 

#### Multilingual support
FREME NER can provide entity recognition in texts written in different languages. Currently, FREME NER suppors following set of languages: English, German, Dutch, Spanish, French, Italian and Russian.
