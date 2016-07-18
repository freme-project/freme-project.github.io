---
layout: page
title: Maintaining the Documentation Project
dropdown: Knowledge Base, FREME for Developers
pos: 4.8
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


## Building Swagger UI

If you want to change anything related to the layout of the api documentation you might want to rebuild the `swagger-ui.js`. The FREME api documentation is based on [this version](https://github.com/swagger-api/swagger-ui/tree/adc8920101ac9923bf07d7bd0d7086204d6d5503) of the official [Swagger UI](https://github.com/swagger-api/swagger-ui). If you are interested in the actual changes done for the FREME api documentation, clone [the used base version of swagger-ui](https://github.com/swagger-api/swagger-ui/tree/adc8920101ac9923bf07d7bd0d7086204d6d5503) and diff it with the `swagger/_swagger-ui` folder of the FREME documentation repository. This folder holds all source code needed to recompile `swagger-ui.js`.

To rebuild `swagger-ui.js` follow these steps:
1. go into the swagger-ui folder: `cd swagger/_swagger-ui`
2. load all needed packages: `npm install`
3. compile `swagger-ui.js`: `npm run build`

After these steps the created `swagger/_swagger-ui/dist` folder contains `swagger-ui.js` and `swagger-ui.min.js`. Replace the ones in the `swagger` folder with these.

Note: The second step has to be done only once.

To ease developing you can use the script [`local-deploy.sh`](https://github.com/freme-project/Documentation/blob/master/local-deploy.sh) in teh root of the documentation project. This script recompiles `swagger-ui.js`, copies it into the `swagger` folder, uses jekyll to rebuild the whole project and copies the result into the `TARGET` folder (modify this in the script!). This folder can be loaded with a local webserver, for instance, to immediately check the result.


