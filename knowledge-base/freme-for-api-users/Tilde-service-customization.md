---
layout: page
title: e-Terminology and e-Translation customization
dropdown: Knowledge Base, FREME for API Users
pos: 4.4
---


# e-Terminology and e-Translation customization

Company [Tilde](http://www.tilde.com) provides two underlaying e-Services For FREME server based on following cloud-based products:

* e-Terminology - enrichments with terminology data
* e-Translation - enrichments with the result of from Machine Translation

Service customization can be done within underlaying specialized portals.

## Table of Contents

* [About Tilde](#about-tilde)
 * [Tilde provided services](#Tilde-provided-services)
 * [Machine Translation Platform](#Machine-Translation-Platform)
 * [Terminology Portal](#Terminology-Portal)
* [Intergration within FREME server](#Intergration-within-FREME-server)
* [e-Terminology customization](#e-Terminology-customization)
* [e-Translation customization](#e-Translation-customization)
* [Contact Information](#Contact-Information)


## About Tilde

[Tilde](http://www.tilde.com)  is a leading European SME, operating from its three offices in the Baltic states and providing jobs for its 135 employees in Tallinn, Vilnius and headquarters in Riga. Tilde has a strong research, development and innovation team with 5 staff PhDs in computer science and computational linguistics. Tilde provides multilingual technology products and services, including localisation, machine translation and terminology, language and reference applications, to its 500,000 users from private and public sectors across EU.

### Tilde provided services
Tilde offers a range of language technology services in several areas: **machine translation**, **terminology**, **proofreading tools**, **speech technology**, and **linguistic tools**.

Available in our cloud platform, these services can be used by developers – through our APIs – to build new multilingual solutions, supporting languages in the digital age.

It includes Machine Translation services for 21 languages, but not restricted, can ensure domain support and process various file and document formats.

Tilde’s online terminology services ensure clear, consistent communication with customers across the globe. With the Terminology API, Tilde provides services that keep terminology organized by identifying terms in documents, finding relevant translations, and assembling term glossaries. These services can be used to build comprehensive terminology solutions.

With Tilde’s Linguistic tool API, users can access linguistic processing components of text data. The Linguistic tool API provides functionality for the following tasks: text tokenisation, sentence breaking, morphological analysis, part of speech (and for morphologically rich languages also morpho-syntactic) tagging, and language detection.


### Machine Translation Platform

Tilde Machine Translation (MT, [tilde.com/mt](http://www.tilde.com/mt) ) is a custom machine translation, tailored to users’ specific translation needs in terminology and style and provided securely on a private cloud or on-prem client infrastructure. Tilde MT demonstrates its particular expertise in smaller and grammatically rich languages and delivers the world’s best translation quality for languages of the Baltic states – Estonian, Latvian and Lithuanian – better than Google Translate and Microsoft Bing.

With Tilde’s Translation API, users can access MT systems in multiple language pairs and domains. The MT systems are hosted in the cloud and can be integrated into any platform or application.

Main features of Tilde MT:

 * Terminology integration
 * Data Library
 * Tag processing
 * CAT integrated
 * Hosting options
 * Linguistic expertise
 * Document translation
 * Preserves formatting
 * LetsMT technology
 * Dynamic Learning
 * Automatic conversions


### Terminology Portal

[Tilde Terminology](https://www.tilde.com/term) embraces the power of the cloud computing and provides next generation terminology services to its users: term candidate identification, extraction and lookup as well as the enrichment of digital content with term translation equivalents.

Main features of Tilde Terminology are:

 * Term candidate identification and extraction
 * Translation candidate lookup 
 * Enrichment of digital content 
 * More than 30 languages
 * Wide domain coverage
 * Private and public collections
 * Team collaboration
 * CAT integrated

Tilde terminolgy is powered by TaaS technology. The TaaS technology, lying behind Tilde Terminology, was developed within the project (7th Framework Programme, ICT), coordinated by Tilde and evaluated by peer reviewers and the European Commission as an excellent project twice in 2013 and 2014.

## Intergration within FREME server
Both Tilde provided e-Services - e-Terminology and e-Translation - are integrated as API requests to Tilde hosted endpoints for content enrichments. 

![Image of dependencies]({{site.basePath  }}/img/Tilde-eservice-integration.png)

Each FREME server installation autheticates in Tilde service endpoint (API) with its authentication token. See FREME configuration article about configuration technical aspects and contact Tilde if you want to set up your custom FREME server and use Tilde provided services.

# e-Terminology customization
Tilde terminology provides enrichment with public terminolgy in more than 30 languages and with wide domain coverage.
But it is possible to use also your own private terminology collections.

![Image of dependencies]({{site.basePath  }}/img/Tilde-terminology-integration.png)

In order to use your private terminology, you have to prepare collection and create a private key at term.tilde.com portal. 
Follow these steps:

 * register at term.tilde.com portal and create your first project (select project type as *private* to keep your data private and secure)
 * create or uploud your terminology: 
  * create terminology from your existing various full-text data, using cutting-edge automatic extraction methods provided by portal
  * create terminology collection from scratch
  * uploud your existing terminology from TBX, Excel, CSV, TSV files
 * find your collection id (below the term list)    
 * create your private security key, that will allow to use your private collection via FREME server, here: https://term.tilde.com/account/keys/create?system=Freme. Later you can manage issued key in youer account setting within term.tilde.com portal.

Now your terminology collection is available for reusing it from FREME server for enrichment of different documents.

Example of CURL request:

``` curl
curl -X POST --header 'Content-Type: text/plain' --header 'Accept: text/turtle' -d 'Text for enrichment' 'https://api.freme-project.eu/current/e-terminology/tilde?source-lang=en&target-lang=de&collection=111222333&key=AAA-BBB-CCC'
```

, where 

 * *source-lang* - language of text for enriching, should be one of your private terminology collection languages.
 * *target-lang* - target-language of your terminology. In case you are not target-language aware, set the same as the 'source-lang'
 * *collection* - Collection ID of your private terminology at term.tilde.com project
 * *key* - your private key for accessing your private collection (in case of wrong private key you will get 'Unauthorized exception')

 See full FREME API documentation to use addition service parameters and filters.

# e-Translation customization

Tilde MT has been created and made available some demo MT system. 

See full list of demo systems here: https://services.tilde.com/translationSystems

It is also possible to use your private MT system from Tilde MT platform. 
Follow these steps:

* log-in or register at Tilde MT portal https://www.letsmt.eu/
* create your own MT system
 * uploud your propriety data
 * you can use also public available text corpora 
 * in case you need an assistance, please contact Tilde Mt team or Tilde global contact
* create your private security key, that will allow to use your private translation system via FREME server

Now your propriety translation system  is ready for reusing it from FREME server for enrichment of different documents.

Example of CURL request:

```curl
curl -X POST --header 'Content-Type: text/plain' --header 'Accept: text/turtle' -d 'Text for enrichment' 'https://api.freme-project.eu/current/e-terminology/tilde?source-lang=en&target-lang=de&collection=111222333&key=AAA-BBB-CCC'
```

, where 

 * *source-lang* - language of text for enriching, should be one of your private terminology collection languages.
 * *target-lang* - target-language of your terminology. In case you are not target-language aware, set the same as the 'source-lang'
 * *collection* - Collection ID of your private terminology at term.tilde.com project
 * *key* - your private key for accessing your private collection (in case of wrong private key you will get 'Unauthorized exception')

See full FREME API documentation to use addition service parameters and filters. 

# Contact Information

Contact Tilde for more info or service customization possibilities.

[langserv@tilde.com](mailto:langserv@tilde.com)  
[@TermServ](https://twitter.com/TermServ)  
[@tilde.com](https://twitter.com/TildeCom)  
[www.tilde.com](www.tilde.com)  
[tilde.com/term](tilde.com/term)   
[tilde.com/mt](tilde.com/mt)  

### HEAD OFFICE:
Tilde  
Vienības gatve 75A  
Riga, LV-1004  
LATVIA  
Phone: +371 67 605 001
