#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#
# This script, when run, parses the file "swagger.yaml" and strips it down to only
# include those paths and methods specified in the included variable.
#
# As of now, it is called with every "jekyll build" - see jekyll-freme/_plugins/jekyll-pages-directory.rb
# line: "exec(python swagger/yamlscript.py)"
#
# To be able to import yaml, on linux, run "sudo pip install PyYAML"
#
# Author: Jonathan Sauder (jonathan_paul.sauder@dfki.de)
#


def main():
	import yaml
	try:
		with open("swagger/swagger.yaml","r") as f:
			full=yaml.load(f.read())
	except IOError:
		print("swagger/swagger.yaml could not be found. A simple-API-Doc was not created")
		return 0
		
	included={
	"/e-entity/freme-ner/documents": ["post"],
	"/e-entity/dbpedia-spotlight/documents": ["post"],
	"/e-publishing/html": ["post"],
	"/e-link/documents/": ["post"],
	"/e-translation/tilde": ["post"],	
	}
	
	for path in full["paths"].keys():
		if path not in included:
			del full["paths"][path]
		else:
			for method in included[path]:
				if method not in full["paths"][path].keys():
					del full["paths"][path][method]
	
	with open("swagger/simple.yaml",'w') as f:
		f.write(yaml.dump(full))
	return 0

if __name__ == '__main__':
	main()

