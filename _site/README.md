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

To see the created site I recommmend opening a new terminal and running
```
jekyll serve
```
This will open a httpserver at localhost:4000 which updates itself everytime the files are edited so no further "build" is needed while working on the project's content.
You will, however have to rebuild when you change configurations in the .yml
