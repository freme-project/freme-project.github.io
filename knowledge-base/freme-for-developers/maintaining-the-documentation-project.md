---
layout: page
title: Maintaining the Documentation Project
dropdown: Knowledge Base, FREME for Developers
pos: 4.8
---

# Maintaining the Documentation Project

The [FREME documentation]({{site.basePath | prepend: site.github.url }}/) uses the static site generator [Jekyll](https://jekyllrb.com/). It contains an [interactive API documentation]({{site.basePath | prepend: site.github.url }}/api-doc/full.html) generated with [Swagger UI](http://swagger.io/swagger-ui/). Furthermore, the documentation is configured for easy deployment via [GitHub Pages](https://pages.github.com/).

## Editing configuration

You can configure parameters in the file [_config.yml](https://github.com/freme-project/freme-project.github.io/blob/master/_config.yml).
The FREME api requests in examples, in the interactive swagger api documentation and the requests which are used to generate dynamic lists of database entities, e.g. of [sparql filters]({{site.basePath | prepend: site.github.url }}/knowledge-base/freme-for-api-users/filtering.html#available-filters), are assembled from the following parameters: 

* `apiProtocol`: The protocol for the FREME api requests, e.g. `http` or `https`
* `apiHost`: The FREME api host, e.g. `api-dev.freme-project.eu` or `api.freme-project.eu`
* `apiBasePath`: The FREME api base path, e.g. `/current`

They should be used in the documentation by prepending `{% raw %}{{ site.apiBasePath | prepend: site.apiHost | prepend: "://" | prepend: site.apiProtocol  }}{% endraw %}` to your requests which will be translated by Jekyll to `<apiProtocol>://<apiHost><apiBasePath>`.

Furthermore, all internal links should be prepended with `{% raw %}{{site.basePath | prepend: site.github.url }}{% endraw %}`, so it is possible to generate links when deployed via [GitHub Pages](https://pages.github.com/) or using [Jekyll](https://jekyllrb.com/) manually. In the first case, `site.github.url` will be set by GitHub pages to the correct host (and to `localhost`, if you built it locally for testing), so `basePath` should be empty. In the later case, `basePath` had to be set to the subfolder where your manually deployed docu resides.

* `basePath`: The documentation base path. Let it empty (or do not define it), if you want to deploy the site via GitHub pages. Set it to the location of the documentation, when you want to deploy it with Jekyll manually, e.g. `/doc`.

## Editing site content

To edit the content of the [pages](https://jekyllrb.com/docs/pages/), just edit the corresponding files. A full guide on how to add Documentation can be found at [here](how-to-add-documentation.html).
To edit the interactive API Documentation, edit `swagger/swagger.yaml`.

## Building the site

### On Api-Dev

Jekyll, github-pages and [html-proofer](https://github.com/gjtorikian/html-proofer)(just needed for [Travis integration](#travis-integration)) are installed on the api-dev server. Every time you push an updated version of this Documentation to the `dev` branch, Jenkins will build a new version.

### On GitHub Pages

When you push to the `master` branch, GitHub Pages rebuilds the live version. But make sure, that the [parameters described above](#editing-configuration) are modified in the correct manner.

### Locally

Install the necessary prerequisites:

1. Jekyll: see [this](https://jekyllrb.com/docs/installation/) for a full guide. Furthermore, [this guide](https://jekyllrb.com/docs/windows/#installation) describes the installation of Jekyll on windows. 
   1. install Jekyll's prerequisites [Ruby](https://www.ruby-lang.org/en/downloads/)(**v2 or above**) and [RubyGems](https://rubygems.org/pages/download)
   2. install Jekyll: `gem install jekyll`
2. github-pages: `gem "github-pages"`, see [this guide](http://jwillmer.de/blog/tutorial/how-to-install-jekyll-and-pages-gem-on-windows-10-x46) for windows.
3. html-proofer: `gem "html-proofer"`

To build the `_site` folder:

```
jekyll build
```

To have the site served correctly (also calls `jekyll build`, updates itself with every edit in the files), run

```
jekyll serve
```

And go to `localhost:4000<basePath>` where `basePath` is like described above.

If you edit files in `_config.yml` then `jekyll serve` will not update these changes automatically. Close the `serve` process and restart it to see the changes.

**NOTE**: There are issues with **auto-regeneration** on windows. Try `jekyll serve --no-watch` if you want to disable it.

### Travis integration

The FREME documentation is configured to verify the Jekyll build process and do some html checks, e.g. link checking, with [html-proofer](https://github.com/gjtorikian/html-proofer) by using [Travis CI](https://travis-ci.org/). Have a look at the [Travis configuration file](https://github.com/freme-project/freme-project.github.io/blob/master/.travis.yml). It defines the `site` parameter to execute the following after every git push to any branch:

```
bundle exec jekyll build && htmlproofer ./_site --url-ignore "/api-doc/full.html#.*/,/api-doc/simple.html#.*/"
```

After building the site with Jekyll, `htmlproofer` is executed. Because links to dynamically generated anchors cause problems, the links to special anchors in the interactive api doc have to be excluded.

You can access the build log via the [Travis dashboard](https://travis-ci.org/) after granting GitHub access for Travis and adding the documentation repository (perhaps you have to **Sync account** to see the repository, then it hides behind `Organizations/FREME` on the left of the [repository overview](https://travis-ci.org/profile)).

## Editing Swagger UI

If you want to change anything related to the layout of the [interactive api documentation]({{site.basePath | prepend: site.github.url }}/api-doc/full.html) you might want to rebuild the `swagger-ui.js`. The FREME api documentation is based on [this version](https://github.com/swagger-api/swagger-ui/tree/adc8920101ac9923bf07d7bd0d7086204d6d5503) of the official [Swagger UI](https://github.com/swagger-api/swagger-ui). If you are interested in the actual changes done for the FREME api documentation, clone [the used base version of swagger-ui](https://github.com/swagger-api/swagger-ui/tree/adc8920101ac9923bf07d7bd0d7086204d6d5503) and diff it with the `swagger/_swagger-ui` folder of the FREME documentation repository. This folder holds all source code needed to recompile `swagger-ui.js`.

## Building Swagger UI

Prerequisites:

* [Node.js](https://nodejs.org)

To rebuild `swagger-ui.js` follow these steps:

1. go into the swagger-ui folder: `cd swagger/_swagger-ui`
2. load all needed packages: `npm install`
3. compile `swagger-ui.js`: `npm run build`

After these steps the created `swagger/_swagger-ui/dist` folder contains `swagger-ui.js` and `swagger-ui.min.js`. Replace the ones in the `swagger` folder with these.

Note: The second step has to be done only once.

To ease developing you can use the script [`local-deploy.sh`](https://github.com/freme-project/Documentation/blob/master/local-deploy.sh) in the root of the documentation project. This script recompiles `swagger-ui.js`, copies it into the `swagger` folder and rebuilds the site.


