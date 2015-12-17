---
layout: page
title: Authentication
dropdown: Knowledge Base
pos: 4.6
---

# Authentication

This Article explains which FREME e-Services need authenticated access and how to perform this.

## Restricted endpoints

Some FREME endpoints are only accessible as authenticated user. At the moment these are:

  * POST, PUT and DELETE `/e-link/templates/{templateID}` (template handling that needs write access)
  * POST, PUT and DELETE `/toolbox/filter/manage/{filterName}` (filter handling that needs write access)
  * GET, DELETE `/user/{userName}` and GET `/user` (user handling, except POST `/user`)

Furthermore, the following FREME endpoints are restricted in such a way, that you can use them only with public resources (e.g. public templates), if you are not authenticated:

  * POST `/e-link/documents`

The result of the resource managament endpoints
  * GET `/e-link/templates`  
  * GET `/toolbox/filter/manage`
differs according to the authenticated user: only the resources to which the user has read access are returned.


  
## Restricted resources

At the moment `templates` and `filters` are restricted.

In general, all public restricted resources can be accessed with read access, writing is permitted. Private restricted resources can not be written, read or used in any FREME e-service by anyone except the owner. By default, a created restricted resource is public. This can be changed by the parameter `visibility` when creating or updating a restricted resource.

## How to authenticate

To perform authenticated endpoint calls you have to do the following:

  1. create an user
  2. retrieve an access token
  3. attach this token to the endpoint call

### How to create a user

If you haven't done before, you have to create an user. This can be established via the [FREME api documentation page]({{site.baseurl | prepend: site.url}}/api-doc/full.html#!/User/post_user) or by performing a POST call to `/user`:
  
```
curl -X POST "{{ site.apiurl | prepend: site.url }}/user?username=YOUR_USERNAME&password=YOUR_PASSWORD"
```

### How to create an access token

An access token can be retrieved via the [FREME api documentation page]({{site.baseurl | prepend: site.url}}/api-doc/full.html#!/Authenticate/post_authenticate) or by calling the `/authenticate` endpoint with your user credentials:

```
curl -X POST --header "X-Auth-Username: YOUR_USERNAME" --header "X-Auth-Password: YOUR_PASSWORD" "{{ site.apiurl | prepend: site.url }}/authenticate"
```

The response will contain your access token. It will look similar to this:

```
  {
      "token": "f81ccf99-1d01-4e79-9a0b-8dfe84d8303c"
  }
```

### How to attach an access token to an API call

To use FREME e-Services as authenticated user just attach your token as `X-Auth-Token` to the request header:

```
curl -X POST --header "X-Auth-Token: f81ccf99-1d01-4e79-9a0b-8dfe84d8303c" "{{ site.apiurl | prepend: site.url }}/e-link/templates?outformat=turtle&informat=json"
```

## User roles

In FREME users can have two roles: ROLE_USER and ROLE_ADMIN. All users registered via the API have ROLE_USER. Admin users can promote normal users to be administrators. An admin user can be configured using the admin.create, admin.username, admin.password configuration options (see [FREME configuration options](http://api-dev.freme-project.eu/doc/knowledge-base/configuration-options.html)).

In general ROLE_USER implies read access to all public resources and to all private resources the user owns. ROLE_USER implies write access to all resources the user owns.

ROLE_ADMIN provides read and write access to all resources in the system.
