---
layout: page
title: FREME Pipelines
dropdown: Knowledge Base, FREME for API Users
pos: 4.7
---

<script>
var xmlhttp = new XMLHttpRequest();
var url = "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates";

xmlhttp.onreadystatechange=function() {
    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        myFunction(xmlhttp.responseText);
    }
}
xmlhttp.open("GET", url, true);
xmlhttp.send();

function myFunction(response) {
    var arr = JSON.parse(response);
    var i;
    var out = "<ul>";

    for(i = 0; i < arr.length; i++) {
        out += "<li>" +
        "<a href=\"{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/"+arr[i].id+"\">"+arr[i].label+"</a>: " + (arr[i].description==null?"(missing description)":arr[i].description) +
        "</li>";
    }
    out += "</ul>";
    document.getElementById("entity-list").innerHTML = out;
}
</script>

# FREME Pipelines

FREME services can be used in various ways and combinations. To achieve reusability of common workflows the FREME pipeline service provides the possibility to forge any sequence of FREME requests into a **FREME pipeline**. Have a look at the tutorial [Using the e-Entity & e-Link Pipeline]({{ site.basePath }}/tutorials/pipeline-entity-link.html) if you want to have a short overview about pipeline usage.

## Contents

* [Predefined pipelines](#predefined-pipelines)
* [Creating a pipeline](#creating-a-pipeline)
* [Using a pipeline](#using-a-pipeline)
* [Manage pipelines](#manage-pipelines)

## Predefined pipelines
<div id="entity-list"></div>

## Creating a pipeline

A FREME pipeline is a **list of request objects**, serialized in [JSON](http://www.json.org/). The following example code shows **one** of these requests:
 
```
{
"method": "POST",
"endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-entity/freme-ner/documents",
"parameters": {
  "language": "en",
  "dataset": "dbpedia"
  },
"headers": {
  "content-type": "text/plain",
  "accept": "text/turtle"
  },
"body": "This summer there is the Zomerbar in Antwerp, one of the most beautiful cities in Belgium."
}
```

The code above defines a request to the FREME-NER service, for a complete explanation of the code we refer to the [e-Entity documentation]({{site.basePath }}/api-doc/full.html#!/e-Entity/executeFremeNer). It sets the mandatory and some optional fields for the request. 

So, every request object has to contain at least these fields:

 * `method`: the HTTP request method. At the moment, only `POST` is supported.
 * `endpoint`: the target where the request will be send to.
 
Furthermore, a request object can define the following:

 * `body`: the body content send to the endpoint
 * `parameters`: a list of key value pairs defining HTTP request parameters
 * `headers`: a list of key value pairs defining HTTP header values


The following example pipeline combines the previous request with another request to the e-Link service, see the [e-Link documentation]({{ site.basePath }}/api-doc/full.html#!/e-Link/enrich) for information regarding the used request parameters:

```
[
{
 "method": "POST",
 "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-entity/freme-ner/documents",
 "parameters": {
   "language": "en",
   "dataset": "dbpedia"
   },
 "headers": {
   "content-type": "text/plain"
   },
 "body": "This summer there is the Zomerbar in Antwerp, one of the most beautiful cities in Belgium."
},
{
  "method": "POST",
  "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-link/documents/",
  "parameters": {
    "templateid": "3"
  },
  "headers": {
    "accept": "text/turtle"
  }
}
]
```

Note the missing `body` field in the second request. For every request except the first one, the result from the previous request is taken as input (body). The same holds for the `content-type` header. But in contrast to the `body` field, it will not be overwritten, if you define it in the pipeline manually.

## Using a pipeline

You can use a pipeline by sending it to the FREME pipeline service at `{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/chain`. This executes every request step by step.

Try this example curl request:

```
curl -X POST -H "Content-Type: application/json" -d '[
{
  "method": "POST",
  "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-entity/freme-ner/documents",
  "parameters": {
     "dataset": "dbpedia", 
    "language": "en"
  },
  "headers": {
    "content-type": "text/plain"
  },
  "body": "This summer there is the Zomerbar in Antwerp, one of the most beautiful cities in Belgium."
},
{
  "method": "POST",
  "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-link/documents/",
  "parameters": {
    "templateid": "1"
  },
  "headers": {
    "content-type": "text/turtle"
  }
}
]' "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/chain"
```

### Pipelines and e-Internalization

FREME e-Services, including the pipeline service, enable automatic conversion of content serialized in some formats like XML or HTML and its conversion back into the input format. This makes content in the mentioned serialization formats processable for the FREME services and is called **roundtripping**. Have a look at the [e-Internalization article]({{ site.basePath }}/knowledge-base/freme-for-api-users/eInternationalisation.html#round-tripping-how-does-it-work) to dig deeper into this topic.
Roundtripping for pipelines is enabled, if the first request of your pipeline or the pipeline service itself is called with one of the e-Internalization **output formats** ([roundtripping formats]({{ site.basePath }}/knowledge-base/freme-for-api-users/gettingStarted_API-users.html#output-types-einternalisation)) as input format and the output format of the last request or the whole pipeline is the same. If enabled, all pipeline internal input and output formats will be changed to TURTLE. If the roundtripping behaviour is not intended, especially if you want to use [XSLT converters]({{ site.basePath }}/knowledge-base/freme-for-api-users/xslt-transformation.html) to process any html or xml input, you can suppress the roundtripping functionality of the pipeline endpoint by adding the query parameter `useI18n=false` to the pipeline request.

Try the following cUrl, which would not work without the parameter because the first xslt converter needs xml as input instead of TURTLE:

```
curl -X POST -H "Content-Type: application/json" -d '[
    {
      "method": "POST",
      "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/toolbox/xslt-converter/documents/xliff20-to-html",
      "headers": {
        "content-type": "text/xml",  
        "accept": "text/xml"
      },
      "body": "<xliff version=\"2.0\" xmlns=\"urn:oasis:names:tc:xliff:document:2.0\" srcLang=\"en\" trgLang=\"fr\">\n <file id=\"f1\">\n  <unit id=\"u1\">\n   <segment>\n   <source>We very much welcome you in the city of Prague, a home of XML!<\/source>\n   <\/segment>\n  <\/unit>\n <\/file>\n<\/xliff>"
    },
    {
      "method": "POST",
      "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-entity/freme-ner/documents?language=en&dataset=dbpedia&mode=all",
      "headers": {
        "content-type": "text/html",
        "accept": "text/html"
      }
    },
    {
      "method": "POST",
      "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/toolbox/xslt-converter/documents/html-to-xliff20",
      "headers": {
        "content-type": "text/xml",
        "accept": "text/xml"
      }
    }
  ]' "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/chain?useI18n=false"
```

### Using a stored pipeline

Any stored pipeline (see [store a pipeline](#store-a-pipeline)) can be used by its `pipelineId` via the endpoint `/pipelining/chain/{pipelineId}`. The mandatory POST body content send to this endpoint will be put into the first pipeline object. The same holds for the `content-type` header (which could be overwritten by the `informat` value), if present. Furthermore, the `accept` header (which could be overwritten by the `outformat` value) is put into the last request object, if present.

Example call to the pipeline with `id=1`:

```
curl -X POST -d 'Berlin is a nice city.' "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/chain/1"
```

### Parametrized pipelines

Sometimes a stored pipeline needs to be configurable. For instance, you do not want to have different pipelines using a translation service for every language combination. The FREME pipeline service allows you to specify parametrized pipelines. Just set the value of a field in the request object to `$VARIABLE_NAME$`, where `VARIABLE_NAME` is chosen by you. It is possible to parametrize values of the following fields or just its parts:

 * `endpoint`
 * values in `parameters`
 * values in `headers`
 
When calling the pipeline service, you have to submit the parameter `VARIABLE_NAME`.



Example pipeline:

```
[
{
  "method": "POST",
  "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-terminology/tilde",
  "parameters": {
    "source-lang": "$source-lang$", 
    "target-lang": "$target-lang$"
  }
},
{
  "method": "POST",
  "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-translation/tilde",
  "parameters": {
    "source-lang": "$source-lang$", 
    "target-lang": "$target-lang$"
  }
}
]
``` 

Assuming the pipeline above has the `id=1`, then you can call it with:

```
curl -X POST -d 'Berlin is a nice city.' "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/chain/1?source-lang=en&target-lang=de"
```


## Manage pipelines

FREME pipelines can be stored in the FREME internal database to make them usable with the endpoint `/pipelining/chain/{pipelineId}` as described above. They can be managed via the REST API endpoint `/pipelining/templates/{pipelineId}`. All pipeline management requests can be executed easily via the [interactive API documentation]({{site.basePath  }}/api-doc/full.html#/Pipelining). Pipelines are restricted resources, so some requests need authenticated access. See [authentication]({{ site.basePath  }}/knowledge-base/freme-for-api-users/authentication.html) for further information.

**NOTE:** When using the following examples, don't forget to replace `YOUR_TOKEN` by your authentication token.

### Store a pipeline

```
curl -X POST --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/json" -d JSON_PIPELINE "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates[?persist=true|false]"
```

The body of the request has to by valid json representing a pipeline object as explained in [Creating a pipeline](#creating-a-pipeline).

The optional parameter `persist` defines, if a pipeline should persist for ever (`true`) or if it should be deleted after one week (`false`, default value).

**NOTE:** In contrast to pipelines, which are intended to be used directly via the endpoint `/pipelining/chain` (instead of `/pipelining/chain/{pipelineId}`), in stored pipelines the `body` field of the first request object will be overwritten by the body content send to `/pipelining/chain/{pipelineId}`. So, the `body` field has to be never defined in stored pipelines.

Example:

```
curl -X POST --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/json" -d '[
   {
     "method": "POST",
     "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-entity/freme-ner/documents",
     "parameters": {
       "language": "en",
       "dataset": "dbpedia"
     },
     "headers": {
       "accept": "text/turtle"
     },
     "body": null
   },
   {
     "method": "POST",
     "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-link/documents/",
     "parameters": {
       "templateid": "1",
       "filter": "extract-entities-only"
     }
   }
 ]' "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/"
```

### Get one pipeline
```
curl -X GET [--header "X-Auth-Token: YOUR_TOKEN"] "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/{pipelineId}"
```

Example:

```
curl -X GET "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/1"
```

### Get all pipelines

This request returns all pipelines to which the currently authenticated user has **read access**, see [authentication]({{ site.basePath  }}/knowledge-base/freme-for-api-users/authentication.html) for further information.

```
curl -X GET [--header "X-Auth-Token: YOUR_TOKEN"] "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates"
```

Example:

```
curl -X GET "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates"
```

### Update a pipeline
```
curl -X PUT --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/json" -d NEW_JSON_PIPELINE "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/{pipelineId}[&newOwner=NEW_OWNER_NAME][&visibility=NEW_VISIBILITY]"
```

Examples:


This changes the pipeline:

```
curl -X PUT --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/json" -d '[
    {
      "method": "POST",
      "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-entity/freme-ner/documents",
      "parameters": {
        "language": "en",
    	"dataset": "dbpedia"
      },
      "headers": {
        "content-type": "text/plain",
        "accept": "text/turtle"
      }
    },
    {
      "method": "POST",
      "endpoint": "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/e-link/documents/",
      "parameters": {
        "templateid": "3",
    	"filter": "extract-entities-only"
      },
      "headers": {
        "content-type": "text/turtle",
        "accept": "text/comma-seperated-value"
      }
    }
]' "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/1"
```

To change the owner, the visibility and the description (this can also be done separately), you can do this:

```
curl -X PUT --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/json" "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/1?newOwner=klaus&visibility=private&description=new%20description"
```

NOTE: The User `klaus` has to exist.

NOTE: The two example requests can be merged, it was splitted just for explanation purposes.

### Delete a pipeline
```
curl -X DELETE --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/{pipelineId}"
```

Example:

```
curl -X DELETE --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/1"
```



