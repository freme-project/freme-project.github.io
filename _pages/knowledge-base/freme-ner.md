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
TODO

## Core Features

#### Domain specific NER
TODO

#### Dataset specific NER
TODO

#### Entity filtering
TODO

#### Multilingual support
TODO

## Stand-alone Version

TODO

``` 
mvn start command
```

# FREME NER via FREME API
TODO
