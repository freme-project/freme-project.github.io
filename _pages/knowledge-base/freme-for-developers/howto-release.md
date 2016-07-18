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

## FREME Java codes release procedure

This guide explains how to prepare the release, how to download the source codes and then how to release the source codes, one after another. Since this is the most difficult part of the release the last section contains tips on trouble-shooting the release.

The dependencies version numbers of all FREME artifacts are centrally defined in the [freme-parent artifact](https://github.com/freme-project/freme-parent). Every pom.xml file in FREME inherits from this artifact. So freme artifacts do not define any dependency version directly in the `<dependencies>` section of the pom.xml but use the version defined in freme-parent. 

### 1. Find out which artifacts have changed. 

You need to check [FREMECommon](https://github.com/freme-project/FREMECommon), [basic services](https://github.com/freme-project/basic-services), [e-Services](https://github.com/freme-project/e-services) and [freme-packages](https://github.com/freme-project/freme-packages) repository. In any case you have to release [freme-parent](https://github.com/freme-project/freme-parent). You need to release only artifacts that have changed since the last release. To identify these artifacts you can check the version numbers in freme-parent. All artifacts with SNAPSHOT versions in freme-parent's `dependencyManagement` tag need to be released. If a version number was set accidently to SNAPSHOT but it has not been released this is no problem. In this case you will release a version without changes. On the other hand, you can be sure that a release version in freme-parent has not been updated since the last release and therefore does not need to be released. It is advised to create a list at first which artifacts need to be released, ordered by repositories.

### 2. Download all source codes

```
git clone https://github.com/freme-project/freme-parent
git clone https://github.com/freme-project/FREMECommon
git clone https://github.com/freme-project/basics-services
git clone https://github.com/freme-project/e-services    
git clone https://github.com/freme-project/freme-ner
git clone https://github.com/freme-project/freme-packages
```

### 3. Update 3rd party licenses files

Update [the relevant sheet of this table](https://docs.google.com/spreadsheets/d/1j2XPwjRLTjyxFm0ceFf_Ts1tmigZEc-YatAWEaciz8k/edit#gid=397366127) with the [Maven Apache License Util](https://github.com/ArneBinder/MavenApacheLicenseUtil), then manually enhance the added rows. Finally generate the needed files. The exact workflow is discribed [here](https://github.com/ArneBinder/MavenApacheLicenseUtil).

It is recommended, but not necessary, to perform this step upon each release.

### 4. Release freme-parent

Every release requires an update of freme-parent. freme-parent defines the version numbers for all FREME artifacts (see above). So you open the pom.xml file and update all version numbers that you plan to release inside of the <dependencyManagement> tag. As already stated in step 1 you release all artifacts that have SNAPSHOT versions. You should be very careful in this step, because a mistake here can mess up the release and be discovered hours later. After updating the versions you open a shell, cd to the directory where the pom.xml of freme-parent is located and release freme-parent by performing these steps:

```
# commit new version to git
git add pom.xml
git commit -m "update version numbers"
mvn release:prepare
mvn release:perform 
```

### 5. Perform other releases

There are two different release procedures, one for single module projects, another one for multi module project. Release the repositories in this order:

1. FREMECommon (single module project)
2. basic services (multi module project)
3. freme-ner (single module project)
4. e-Services (multi module project)
5. freme-packages (single module project)

#### Release of single module project

Execute this shell script:

```
# update parent artifact to latest version
mvn versions:update-parent
mvn versions:commit	
git add .
git commit -m "update parent artifact version"
git push origin master

# perform release
mvn release:prepare
mvn release:perform
```

#### Release of multi module project

Releasing a multi module artifact involves some manual work. The goal is to release only the artifacts that have changed since the last release.

* Open each artifacts pom.xml that you want to release and update the parent artifacts version to the latest release version. Then remove the "-SNAPSHOT" suffix from the artifacts version. Now the version of this artifact is the same that is specified in freme-parent earlier in the release process. In freme-packages repository you do not need to update the artifacts version because it is defined by the parent version.
* Run `mvn -DskipTests=true install` to find out if all dependencies can be resolved.
* Run this shell script to commit the source codes to Jenkins. This will trigger Jenkins to run all unit tests, build all artifacts and upload the release artifacts to the maven repository. Replace "x.y" with the version number of the release.

```
git status (you need to make sure that you commit only pom.xml files into the repository)
git add .
git commit -m "release freme x.y"
git push origin master
```

* Wait until Jenkins has finished. When Jenkins has finished without problems then create the release tag:

```
git tag -a "e-services-x.y"     # replace the tag name with the name of the artifact and the version number
git push origin e-services-x.y
```

* In every pom.xml that you have released, update the parent artifact to the latest snapshot (e.g. from freme-parent:0.8 to freme-parent:0.9-SNAPSHOT). Update the artifact version to a new snapshot version, so when you just released version 0.8, then you update the version to 0.9-SNAPSHOT. You do not need to update the artifact version in a freme-package because it is already defined by the parent version. Then commit these changes to the repository:

```
git add .
git commit -m "upgrade version numbers to snapshot"
git push origin master
```

## Deployment on the server

This section explains how to create the freme-packages for the broker and freme-ner and install them on the servers. In FREME the broker runs on the freme-live server, while freme-ner runs on the freme-worker server. Requests to freme-ner will be proxied by the broker to the freme-worker server. Create freme-packages. Checkout the release tag and create the freme packages. See also [Create and run a FREME package](../freme-for-sysadmins/creating-and-running-a-freme-package.html) and [Start FREME](../freme-for-sysadmins/install-freme-on-server.html) for more detailed information. This guide assumes that you have a server that meets the [FREME hardware requirements](..//freme-for-sysadmins/freme-hardware-requirements.html). It also assumes that the server fulfills software requirements, has Java 8 installed, maybe a MySQL database and other software that specific e-Services need. This guide explains how to deploy FREME NER and then explains which steps to change to deploy the broker.

### Deploy FREME NER               

#### 1. Backup MySQL database.

I usually do this using MySQL workbench. Make sure to backup both structure and data.

#### 2. Download the release tag of the FREME package and create the package:

```
git clone https://github.com/freme-project/freme-packages
git tag # print all git tags
git checkout tags/release-0.8    # replace "freme-0.8" with the name of the release tag 
cd broker-dev
mvn package
cd target
```

#### 3. Update configuration

Now the FREME package is located in the folder `freme-distribution`. Usually you need to open the configuration file in `config/application.properties` and enter the database credentials. Usually you can copy & paste them from the installation that is currently running. You should also ensure that the port that freme-ner uses is the same as in the current running version. You can find the existing configuration on the freme-worker server in `/opt/freme-ner-live/config/application.properties`.
 
#### 4. Transfer FREME to the server and run it.

```
scp -r freme-package u235827@rv2622.1blu.de:
ssh u235827@rv2622.1blu.de
cd /opt/freme-ner-live
bin/stop_server.sh
sudo mv /opt/freme-ner-live/ /opt/freme-ner-live-backup/
sudo mv ~/freme-package /opt/freme-ner-live
cd /opt/freme-ner-live
chmod +x bin/*
bin/start_server
tail -f logs/broker.log
```

Now you should wait until the application has started. Then you can test the FREME NER API by doing API calls directly to `http://rv2622.1blu.de:7002/e-entity/freme-ner/documents`. When everything works fine the last step is to delete the backup:

```
rm -rf /opt/freme-ner-live-backup
```

Usually the application is configured with `spring.jpa.hibernate.ddl-auto=none`. When FREME fails to start because of database issues maybe you have to update the MySQL table structure. The configuration line `spring.jpa.hibernate.ddl-auto=update` will automatically update the MySQL database tables when the structure has changed. You should examine the log files and see if any database tables have changed. If this is the case you have to examine the database and see if all the data still exists in the tables that have changed.

## Deploying the broker

Deploying the broker is very similar to deploying FREME NER. You use the package `broker-dev` instead of `freme-ner-dev`. Then you copy the package to `api.freme-project.eu` server instead of `rv2622.1blu.de`. The installation directory is `/opt/freme/FREME-xy`. You should make sure to stop the old broker before starting the new broker.

## Trouble Shooting FREME release

* Sometimes a release takes a lot of time because of the unit tests. Especially when you fix a bug and run the release many times it is annoying to wait for the unit tests. In this case you can use `mvn -DskipTests=true release:prepare`  `mvn -DskipTests=true release:perform` to skip the unit tests.
* The release of a single artifacts consists of the two maven goals `mvn release:prepare` and `mvn release:perform`. Sometimes `mvn release:perform` fails and the bugfix requires a change in the source codes or the pom.xml. In this case you need to undo the changes of `mvn release:prepare`. Open the pom.xml and rewind the version number. Then [delete the git release tag](https://confluence.atlassian.com/bitbucket/how-do-i-remove-or-delete-a-tag-from-a-git-repo-282175551.html). Then you can commit your bugfix to the Git repository and start the release process again with  `mvn release:prepare`.
* Sometimes you have released an artifact and then you find out that there is a bugfix that needs to be released. In this case you need to undo the release. Therefore you need to undo the changes in the pom.xml file, [delete the release tag](https://confluence.atlassian.com/bitbucket/how-do-i-remove-or-delete-a-tag-from-a-git-repo-282175551.html) and delete the artifact from the maven repository.

# Release of the documentation

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






