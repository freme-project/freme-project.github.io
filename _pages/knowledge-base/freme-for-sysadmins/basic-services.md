---
layout: page
title: Basic services
dropdown: Knowledge Base, FREME for System Administrators
pos: 4.16
---

This page lists all basic services that have been developed during the course of the FREME project.

* TOC
{:toc}

# Proxy filter

The proxy filter receives HTTP requests and proxies these requests to a remote location. It copies the request, including headers, query string parameters and request body. It performs marginal changes in the request, e.g. it exchanges the "HOST" header. It proxies GET, POST, PUT, DELETE and OPTIONS requests. Multiple proxies can be configured using this filter.

**Quick overview**

| Maven artifact  | eu.freme.bservices.proxy-filter  |
| Spring configuration file | spring-configurations/proxy-filter.xml  |
| Source code location | [link](https://github.com/freme-project/basic-services/tree/master/filters/proxy-filter)  |
| Packages that contain proxy service | [broker-dev](https://github.com/freme-project/freme-packages/tree/master/broker-dev) |

**Configuration options**

The proxy filter is configured using application properties, e.g. in the configuration file application.properties. The configuration has this form:

proxy.proxy-id.servlet_url: /e-entity/freme-ner/documents
proxy.proxy-id.target_url: http://example.org/freme-ner

Each proxy configuration consists of two lines. The first line configures the API endpoint on the proxy server that the server listens on. The second line configures the destination URL to which requests are being proxied. Each configuration option consists of three segments: proxy, proxy-id and servlet_url / target_url. The first segment is always the same for the proxy configurations. The second segment denotes the ID of this proxy. When configuring multiple proxies then different proxies can be distinguished by their ID.

**Example configuration**

proxy.freme-ner-documents.servlet_url: /e-entity/freme-ner/documents
proxy.freme-ner-documents.target_url: http://rv2622.1blu.de:7001/e-entity/freme-ner/documents
