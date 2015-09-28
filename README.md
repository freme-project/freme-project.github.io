# Documentation

## License

Copyright 2015 Deutsches Forschungszentrum f�r K�nstliche Intelligenz

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

This project uses 3rd party tools. You can find the list of 3rd party tools including their authors and licenses [here](3RD-PARTY-LICENCES).

----------------------------------------------------------------------------



To use:

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

To edit the content, edit the files in the _pages folder
When pushing this to the FREME server make sure to adapt the "basepath" parameter in _config.yml before building with jekyll
