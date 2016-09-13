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
        "<a href=\"{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/toolbox/xslt-converter/manage/"+arr[i].id+"\">"+arr[i].label+"</a>: " + (arr[i].description==null?"(missing description)":arr[i].description) +
        "</li>";
    }
    out += "</ul>";
    document.getElementById("entity-list").innerHTML = out;
}
</script>

# FREME Pipelines

FREME services can be used in various ways and combinations. To achieve reusability of common workflows the FREME pipelines service provides the possibility to forge any sequence of FREME requests into a **FREME pipeline**.

## Contents

* [Predefined pipelines](#predefined-pipelines)
* [Defining a pipeline](#defining-a-pipeline)
* [Using a pipeline](#using-a-pipeline)
* [Manage pipelines](#manage-pipelines)

## Predefined pipelines
<div id="entity-list"></div>

## Defining a pipeline

## Using a pipeline

## Manage pipelines

FREME pipelines can be stored easily in the FREME internal database. They can be managed via the REST API endpoint `/pipelining/templates/{pipelineId}`. All pipeline management requests can be executed easily via the [interactive API documentation]({{site.basePath | prepend: site.github.url }}/api-doc/full.html#/Pipelining). Pipelines are restricted resources, so some requests need authenticated access. See [authentication]({{ site.basePath | prepend: site.github.url }}/knowledge-base/freme-for-api-users/authentication.html) for further information.

**NOTE:** When using the following examples, don't forget to replace `YOUR_TOKEN` by your authentication token.

### Store a pipeline

```
curl -X POST --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/json" -d JSON_PIPELINE "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates"
```

The body of the request has to by valid json representing a pipeline object as explained in [Defining a pipeline](#defining-a-pipeline).

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

This request returns all pipelines to which the currently authenticated user has **read access**, see [authentication]({{ site.basePath | prepend: site.github.url }}/knowledge-base/freme-for-api-users/authentication.html) for further information.

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

### Delete a XSLT converter
```
curl -X DELETE --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/{pipelineId}"
```

Example:

```
curl -X DELETE --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/pipelining/templates/1"
```



