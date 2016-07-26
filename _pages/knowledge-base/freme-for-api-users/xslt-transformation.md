---
layout: page
title: XSLT transformation via FREME
dropdown: Knowledge Base, FREME for API Users
pos: 4.7
---

<script>
var xmlhttp = new XMLHttpRequest();
var url = "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage";

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
        "<a href=\"{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage/"+arr[i].name+"\">"+arr[i].name+"</a>: " + (arr[i].description==null?"(missing description)":arr[i].description) +
        "</li>";
    }
    out += "</ul>";
    document.getElementById("converter-list").innerHTML = out;
}
</script>

# XSLT transformation via FREME

FREME let you use a wide area of XML and HTML content for its e-Services. This is possible by previously transforming the input with [XSLT stylesheets](https://www.w3.org/Style/XSL/WhatIsXSL.html) into acceptable FREME input. The workflow can be forged into a **FREME pipeline** to achieve reusability.

## Contents

* [Available XSLT converter](#available-xslt-converter)
* [Using XSLT converter](#using-xslt-converter)
* [Manage XSLT converter](#manage-xslt-converter)

## Available XSLT converter
<div id="converter-list"></div>

## Using XSLT converter

Any available converter can be used by sending XML or HTML content to the endpoint `{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/CONVERTER-NAME`:

```
curl -X POST --header 'Content-Type: text/html' -d '<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>The HTML5 Herald</title>
    <meta name="description" content="The HTML5 Herald">
    <meta name="author" content="SitePoint">
</head>
<body>
<p>hello world</p>
</body>
</html>' '{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/documents/identity-transformation'
```

The request above simply transforms any valid html document into valid xml. The result should look like:

```
<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
   <head>
      <meta charset="utf-8"/>
      <title>The HTML5 Herald</title>
      <meta name="description" content="The HTML5 Herald"/>
      <meta name="author" content="SitePoint"/>
   </head>
   <body>
      <p>hello world</p>

   </body>
</html>
```

**NOTE:** The endpoint defaults to `text/xml` for both, the type of the input and output. If you submit HTML content, you have to set the header `Content-Type: text/html`. To get HTML back, set the header `Accept: text/html`.

**NOTE:** Using CURL makes it necessary to set the Content-Type header also for `text/xml`.

You can play around with existing converters at the [interactive FREME api documentation]({{site.baseurl | prepend: site.url}}/api-doc/full.html#resource_Toolbox/XSLT-Converter).

### Submitting stylesheet parameters

Using a stylesheet that defines global parameters makes it possible to set them while calling the converter. To do so, just submit the parameter-value-pairs with the request.

Have a look at the stylesheet of the converter [xslt-with-param]({{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage/xslt-with-param):

```
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="myparam">set internally</xsl:param>
    <xsl:template match="/">
        <xsl:value-of select="$myparam"/>
    </xsl:template>
</xsl:stylesheet>
```

The stylesheet simply outputs the content of the parameter `myparam` and discards the input. So when you call:

```
curl -X POST --header 'Content-Type: text/xml' -d '<?xml version="1.0"?>
<note>
    <to>Tove</to>
    <from>Jani</from>
    <heading>Reminder</heading>
    <body>Dont forget me this weekend!</body>
</note>' '{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/documents/xslt-with-param'
```

you get this:

```
<?xml version="1.0" encoding="UTF-8"?>set internally
```

But adding the parameter `myparam` to the request:

```
curl -X POST --header 'Content-Type: text/xml' -d '<?xml version="1.0"?>
<note>
    <to>Tove</to>
    <from>Jani</from>
    <heading>Reminder</heading>
    <body>Dont forget me this weekend!</body>
</note>' '{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/documents/xslt-with-param?myparam=content'
```

gives this result:

```
<?xml version="1.0" encoding="UTF-8"?>content
```


## Manage XSLT converter

XSLT converters can be managed via the REST API endpoint `/toolbox/xslt-converter/manage/{converterName}`. All XSLT converter management requests can be executed easily via the [interactive API documentation]({{site.baseurl | prepend: site.url}}/api-doc/full.html#resource_Toolbox/XSLT-Converter). XSLT converters are restricted resources, so some requests need authenticated access. See [authentication]({{ site.apiurl | prepend: site.url }}/doc/knowledge-base/freme-for-api-users/authentication.html) for further information.

**NOTE:** When using the following examples, don't forget to replace `YOUR_TOKEN` by your authentication token.

### Add a XSLT converter

```
curl -X POST --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/plain" -d XSLT_STYLESHEET "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage?name={converterName}"
```

The body of this request has to be a valid [XSLT stylesheet](https://www.w3.org/TR/xslt).

Example:

```
curl -X POST --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/plain" -d "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<xsl:stylesheet xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\"\n    xmlns:xs=\"http://www.w3.org/2001/XMLSchema\"\n    exclude-result-prefixes=\"xs\"\n    version=\"2.0\">\n    <xsl:template match=\"node()|@*\">\n        <xsl:copy>\n            <xsl:apply-templates select=\"node()|@*\"></xsl:apply-templates>\n        </xsl:copy>\n    </xsl:template>\n</xsl:stylesheet>" "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage?name=identity-transform"
```

### Get one XSLT converter
```
curl -X GET [--header "X-Auth-Token: YOUR_TOKEN"] "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage/{converterName}"
```

Example:

```
curl -X GET "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage/identity-transform"
```

### Get all XSLT converters

This request returns all converters to which the currently authenticated user has **read access**, see [authentication]({{ site.url }}/doc/knowledge-base/freme-for-api-users/authentication.html) for further information.

```
curl -X GET [--header "X-Auth-Token: YOUR_TOKEN"] "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage"
```

Example:

```
curl -X GET "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage"
```

### Update a XSLT converter
```
curl -X PUT --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/plain" -d NEW_XSLT_STYLESHEET "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage/{converterName}[&newOwner=NEW_OWNER_NAME][&visibility=NEW_VISIBILITY]"
```

Examples:


This changes the converter:

```
curl -X PUT --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/plain" -d "<xsl:stylesheet xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\" version=\"1.0\">\n    <xsl:param name=\"myparam\">set internally</xsl:param>\n    <xsl:template match=\"/\">\n        <xsl:value-of select=\"$myparam\"/>\n    </xsl:template>\n</xsl:stylesheet>\n" "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage/identity-transform"
```

To change the owner, the visibility and the description (this can also be done separately), you can do this:

```
curl -X PUT --header "X-Auth-Token: YOUR_TOKEN" --header "Content-Type: text/plain" "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage/identity-transform?newOwner=klaus&visibility=private&description=new%20description"
```

NOTE: The User `klaus` has to exist.

NOTE: The two example requests can be merged, it was splitted just for explanation purposes.

### Delete a XSLT converter
```
curl -X DELETE --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage/{converterName}"
```

Example:

```
curl -X DELETE --header "X-Auth-Token: YOUR_TOKEN" "{{ site.apiurl | prepend: site.url }}/toolbox/xslt-converter/manage/identity-transform"
```



