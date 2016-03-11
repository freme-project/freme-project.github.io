---
layout: page
title: Maintaining the Documentation Project
dropdown: Knowledge Base
pos: 4.7
---

# Maintaining the Documentation Project

## Editing configuration


You can configure parameters in the file `_config.yml`.

* The `url` parameter should be the hostname & protocol for this site e.g {{site.url}}
* The `baseurl` parameter should be the subpath of where this documentation site is hosted e.g. "/doc/0.x"
* The `apiurl` parameter should be the subpath to the FREME Api that all requests made from this documentation site go to, e.g. {{site.apiurl}}



## Editing content

To edit the content of the pages, edit the files in the `_pages` folder. A full guide on how to add Documentation can be found at [here](how-to-add-documentation.html).
To edit the API Documentation, edit `swagger/swagger.yaml`.


## Building

**On Api-Dev**

Jekyll, the Static Site Generator for this project is installed on the api-dev server. Every time you push an updated version of this Documentation to the master branch, Jenkins will build a new version, so you don't need Jekyll installed.

**Locally**

Install jekyll

```
sudo apt-get install jekyll
```

If the paket Jekyll cannot be installed try installing the ruby-dev package and then try to install jekyll again:

```
sudo apt-get install ruby-dev
```



To build the _site folder:

```
jekyll build
```

To have the site served correctly (also calls `jekyll build`, updates itself with every edit in the files), run

```
jekyll serve
```

And go to `localhost:4000/<baseurl>/start.html` where baseurl is as of now `doc`.  Each call to `jekyll serve` will execute `swagger/yamlscript.py` which generates the Simple Api Documentation from the Full Api Documentation.

If you edit files in `_config.yml` then `jekyll serve` will not update these changes automatically. Close the `serve` process and restart it to see the changes.


## Migrating Swagger-UI versions

Change into the `swagger-ui` branch of the [documentation project](https://github.com/freme-project/Documentation/tree/swagger-ui).

Replace all files with the new Swagger-UI files except for:

* `src/main/template/resource.handlebars`
* `src/main/javascript/MainView`
* `src/main/javascript/ResourceView`

**Build the new dist directory**
Build the new `dist` directory for Swagger UI from the `swagger-ui` branch by changing into the directory containing `gulpfile.js` and running:

```
npm install
gulp
```

You should now see a new directory `dist`. If this did not work, make sure you have `npm` and `gulp` properly installed.

**Merge new dist folder into existing Documentation master**

Replace every file in the `swagger` directory in the `master` branch with the new files from the `dist` directory created previously except:

* `/swagger/swagger.yaml`
* `/swagger/lib/jquery-1.9.1.min.js`

See if this works out of the box by running `jekyll serve` as describe above. If it does, then you are done.

If it does not, replace the javascript in `_layouts/swagger-doc.html` with the javascript in `swagger/index.html`.
Uncomment the function `addApiKeyAuthorization` and replace the line

```
var apiKeyAuth = new SwaggerClient.ApiKeyAuthorization("api_key", key, "query");
```

with

```
var apiKeyAuth = new SwaggerClient.ApiKeyAuthorization("X-Auth-Token", key, "header");
```
to enable the use of X-Auth-Tokens in the documentation.
If there are unresolved dependencies, add them in `_layouts/swagger-doc.html` with the correct relative path.

