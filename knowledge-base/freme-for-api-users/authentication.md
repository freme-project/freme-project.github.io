---
layout: page
title: Authentication
dropdown: Knowledge Base, FREME for API Users
pos: 4.1
---

# Authentication

This Article explains which FREME e-Services need authenticated access and how to perform this.

## Restricted endpoints

Some FREME endpoints are only accessible as authenticated user. At the moment these are:

  * POST, PUT and DELETE `/e-link/templates/{templateID}` (template handling that needs write access)
  * POST, PUT and DELETE `/toolbox/convert/manage/{filterName}` (filter handling that needs write access)
  * POST, PUT and DELETE `/pipelining/templates/{pipelineID}` (pipeline handling that needs write access)
  * POST, PUT and DELETE `/e-entity/freme-ner/datasets/{datasetName}` (dataset handling that needs write access)
  * POST, PUT and DELETE `/toolbox/xslt-converter/manage/{converterName}` (xslt-converter handling that needs write access)
  * GET, DELETE `/user/{userName}` and GET `/user` (user handling, except POST `/user`)

Furthermore, the following FREME endpoints are restricted in such a way, that you can use them only with public resources (e.g. public templates), if you are not authenticated:

  * POST `/e-link/documents`
  * POST `/toolbox/convert/documents/{filterName}`
  * POST `/pipelining/chain/{pipelineID}`
  * POST `/e-entity/freme-ner/documents`
  * POST `/toolbox/xslt-converter/documents/{converterName}`

The result of the resource management endpoints

  * GET `/e-link/templates`  
  * GET `/toolbox/convert/manage`
  * GET `/pipelining/templates`
  * GET `/e-entity/freme-ner/datasets`
  * GET `/toolbox/xslt-converter/manage`

differs according to the authenticated user: only the resources the user has read access to are returned.


  
## Restricted resources

At the moment **templates**, **filters**, **pipelines**, **datasets** and **xsltconverter** are restricted.

In general, all public restricted resources can be accessed with read access, writing is permitted. Private restricted resources can not be written, read or used in any FREME e-service by anyone except the owner. By default, a created restricted resource is public. This can be changed by the parameter `visibility` when creating or updating a restricted resource.

## How to authenticate

To perform authenticated endpoint calls you have to do the following:

  1. create an user
  2. retrieve an access token
  3. attach this token to the endpoint call
  
If you want to get the full FREME user management functionality have a look at the [FREME api documentation]({{site.basePath | prepend: site.github.url }}/api-doc/full.html#!/User). 

### How to create a user

If you haven't done before, you have to create an user. This can be established via the [FREME api documentation page]({{site.basePath | prepend: site.github.url }}/api-doc/full.html#!/User/post_user) or by performing a POST call to `/user`:
  
```
curl -X POST "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/user?username=YOUR_USERNAME&password=YOUR_PASSWORD"
```

### How to create an access token

An access token can be retrieved via the [FREME api documentation page]({{site.basePath | prepend: site.github.url }}/api-doc/full.html#!/User/post_authenticate) or by calling the `/authenticate` endpoint with your user credentials:

```
curl -X POST --header "X-Auth-Username: YOUR_USERNAME" --header "X-Auth-Password: YOUR_PASSWORD" "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/authenticate"
```

The response will contain your access token. The access token is valid forever and will never expire. Currently there is no way to delete an access token via the API, they can only be deleted directly from the database. An access token looks similar to this:

```
  {
      "token": "f81ccf99-1d01-4e79-9a0b-8dfe84d8303c"
  }
```

### How to attach an access token to an API call

To use FREME e-Services as authenticated user just attach your token as `X-Auth-Token` to the request header. For the following example, the X-Auth-Token header is not necessary, but it is the case if you use this call to access a private dataset.

```
curl -X POST --header "Content-Type: text/plain" --header "Accept: text/n3" --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol }}/e-entity/freme-ner/documents?input=Welcome%20to%20Berlin%2C%20the%20capital%20of%20Germany.&language=en&dataset=dbpedia&mode=all"
```

To use restricted resources via the [FREME api documentation]({{site.basePath | prepend: site.github.url }}/api-doc/full.html) just put your token into the input field at the bottom of the page.

### OPTIONAL: How to change the password of a user

To do so, you have to use an access token of the User you want to update or from the admin.
You can use the [FREME api documentation page]({{site.basePath | prepend: site.github.url }}/api-doc/full.html#!/User/put_user_username) or a curl call like the following:

```
curl -X PUT --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/user/YOUR_USERNAME?password=NEW_PASSWORD"
```

### OPTIONAL: How to delete a user

You have to use an access token of the user you want to delete or from the admin.
You can use the [FREME api documentation page]({{site.basePath | prepend: site.github.url }}/api-doc/full.html#!/User/delete_user_username) or a curl call like the following:

```
curl -X DELETE --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}/user/YOUR_USERNAME"
```
It is not yet possible to delete a user who still owns resources such as datasets or templates. This will be implemented.

## User roles

In FREME users can have two roles: ROLE_USER and ROLE_ADMIN. All users registered via the API have ROLE_USER. Admin users can promote normal users to be administrators. An admin user can be configured using the admin.create, admin.username, admin.password configuration options (see [FREME configuration options]({{site.basePath | prepend: site.github.url }}/knowledge-base/freme-for-sysadmins/configuration-options.html)).

In general ROLE_USER implies read access to all public resources and to all private resources the user owns. ROLE_USER implies write access to all resources the user owns.

ROLE_ADMIN provides read and write access to all resources in the system.
