---
layout: page
title: How to do a FREME release
dropdown: Knowledge Base, FREME for Developers
pos: 4.11
---

# How to do a FREME release

This guide explains how to perform a FREME release. First it explains how to do release the FREME Java codes, from pre-requisites, over the release itself to the deployment on the server. In the last chapter it explains how to perform a release of the Documentation.

## Prerequisites

* When performing the release, nobody else should be doing changes in the code (code freeze).
* Before the release, check in Jenkins if all unit tests are ok. When a unit test fails, either fix the bug or configure JUnit to ignore the test.
* It is recommended to perform a release from a linux or mac shell. I use an ubuntu machine, the command line interface to perform all the commands and gedit to edit the pom.xml files.
* You need a GitHub account that has read/write access to all repositories you want to release. Further you need write access to the FREME maven repositories, both release and snapshot.
* The Maven artifacts will be published on Maven Central. Therefore you need [configure access to Maven central](./publish-maven-artifacts.html).

## FREME Java codes release procedure

This guide explains how to prepare the release, how to download the source codes and then how to release the source codes, one after another. Since this is the most difficult part of the release the last section contains tips on trouble-shooting the release.

The dependencies version numbers of all FREME artifacts are centrally defined in the [freme-parent artifact](https://github.com/freme-project/freme-parent). Every pom.xml file in FREME inherits from this artifact. So freme artifacts do not define any dependency version directly in the `<dependencies>` section of the pom.xml but use the version defined in freme-parent. 
  
In general we advise to release all FREME artifacts together. Also if a project did not change since the last release, it is possible that one of the dependencies has changed. To avoid forgetting about changes and side effects like this, all artifacts are released together.
  
### 1. Download all source codes

```
git clone https://github.com/freme-project/freme-parent
git clone https://github.com/freme-project/FREMECommon
git clone https://github.com/freme-project/basics-services
git clone https://github.com/freme-project/e-services    
git clone https://github.com/freme-project/freme-ner
git clone https://github.com/freme-project/freme-packages
```

### 2. Release freme-parent

Every release requires an update of freme-parent. freme-parent defines the version numbers for all FREME artifacts (see above). So you open the pom.xml file and update all version numbers that you plan to release in of the <dependencyManagement> tag. Usually you upgrade the version numbers of all artifacts in the dependencyManagement tag.

```
# commit new version to git
git add pom.xml
git commit -m "update version numbers"
mvn release:prepare
mvn release:perform 
```

### 3. Perform other releases


```
# update dependency on freme-parent artifact to latest version (replace XYZ with the version of freme-parent)
mvn versions:update-parent -DparentVersion="XYZ"
mvn versions:commit	
git add .
git commit -m "update parent artifact version"
git push origin master

# perform release
mvn release:prepare
mvn release:perform
```

### 4. Deploy release

In this step you checkout the release git tag of the freme package you want to deploy. Then you follow the guide [Create and run a FREME package](../freme-for-sysadmins/creating-and-running-a-freme-package.html).

## Trouble Shooting FREME release

* Sometimes a release takes a lot of time because of the unit tests. Especially when you fix a bug and run the release many times it is annoying to wait for the unit tests. In this case you can use `mvn -DskipTests=true release:prepare`  `mvn -DskipTests=true release:perform` to skip the unit tests.
* The release of a single artifacts consists of the two maven goals `mvn release:prepare` and `mvn release:perform`. Sometimes `mvn release:perform` fails and the bugfix requires a change in the source codes or the pom.xml. In this case you need to undo the changes of `mvn release:prepare`. Open the pom.xml and rewind the version number. Then [delete the git release tag](https://confluence.atlassian.com/bitbucket/how-do-i-remove-or-delete-a-tag-from-a-git-repo-282175551.html). Then you can commit your bugfix to the Git repository and start the release process again with  `mvn release:prepare`.
* Sometimes you have released an artifact and then you find out that there is a bugfix that needs to be released. In this case you need to undo the release. Therefore you need to undo the changes in the pom.xml file, [delete the release tag](https://confluence.atlassian.com/bitbucket/how-do-i-remove-or-delete-a-tag-from-a-git-repo-282175551.html) and delete the artifact from the maven repository.

## Release of the documentation

The API documentation resides in https://github.com/freme-project/Documentation. To release it you need to perform the following steps. Replace x by the version number of the Documentation.

* Download sources:  `git clone https://github.com/freme-project/Documentation`
* change _config.yml to the live version of freme:
    * url: "api.freme-project.eu"
    * apiurl: "/0.x"
    * baseurl: "/doc/0.x"
* change swagger/swagger.yaml to the live version of freme
    * host: "api.freme-project.eu"
    * basePath: "/0.x"
* commit and push the change to GitHub
* `mvn release:prepare` (normally you can answer all questions with the suggested values)
* `mvn release:perform -Dgoals=install` The parameter -Dgoals=install will skip artifact deployment
* Zip the documentation and copy it to freme-dev, folder `/var/www/html/freme-distributions/`
* Copy the documentation to freme-live, folder `/var/www/html/doc/0.x`
* Now the documentation is released. Now you should 
    * update the swagger/swagger.yaml again and change the `host: "api-dev.freme-project.eu` and `basePath: "/current"`. Then git commit and push. 
    * update the _config.yaml again and change the `url: "api-dev.freme-project.eu"` and `apiurl: "/current"`  






