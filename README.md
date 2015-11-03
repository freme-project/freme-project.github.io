# Documentation

## License

Copyright 2015 Agro-Know, Deutsches Forschungszentrum für Künstliche Intelligenz, iMinds,
               Institut für Angewandte Informatik e. V. an der Universität Leipzig,
               Istituto Superiore Mario Boella, Tilde, Vistatec, WRIPL

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

This project uses 3rd party tools. You can find the list of 3rd party tools including their authors and licenses [here](LICENSE-3RD-PARTY).

----------------------------------------------------------------------------

#Maintaining the Documentation Project

##Editing content

To edit the content of the pages, edit the files in the `_pages` folder. A full guide on how to add Documentation can be found at [here](api-dev.freme-project.eu/doc/knowledge-base/how-to-add-documentation.html).
To edit the API Documentation, edit `swagger/swagger.yaml`.

You can configure parameters such as `baseurl`, `url`, `fremeapiurl` (used for FREME Showcase) in the file `_config.yml`.

##Building

**On Api-Dev**

Jekyll, the CMS for this project is installed on the api-dev server. Everytime you push an updated version of this Documentation to the master branch, Jenkins will build a new version, so you don't need Jekyll installed.

**Locally**

Install jekyll

``` 
sudo apt-get install jekyll 
```

If it doesn't work the first time go for:

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
