---
layout: page
title: Publish Maven artifacts
dropdown: Knowledge Base, FREME for Developers
pos: 4.13
---

# Publish Maven artifacts in Central Repository
All FREME artifcats can be found in the 
[Central Repository](http://central.sonatype.org/?__hstc=239247836.b459aee40da923fa4a45645a31cddadf.1477582531140.1477582531140.1477605428269.2&__hssc=239247836.1.1477605428269&__hsfp=190473045&__utma=246996102.1998389910.1476968965.1477571303.1477605428.9&__utmb=246996102.2.10.1477605428&__utmc=246996102&__utmx=-&__utmz=246996102.1477468869.3.2.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided)&__utmv=-&__utmk=44786983) 
so everyone can access them easily.

This article shall help developpers to prepare their artifacts such that they can be uploaded to the repository. For 
detailed instructions, have a look at the [official documentation](http://central.sonatype.org/pages/producers.html).

## Getting access

First of all, you need to sign up to [Sonatype JIRA](https://issues.sonatype.org/secure/Signup!default.jspa) which 
automatically creates a JIRA issue for your request. You will be asked to enter the groupID for your artifacts and for 
some additional information such as the website of your project. The groupID of the FREME project is 
**eu.freme-project**, i.e. in the [repository](https://repo1.maven.org/maven2/) you will find it under
**eu/freme-project**.

Before you can actually upload artifacts you will have to wait for Sonatype to review the information that you  provided. 
This  can take up to two buisiness days but usually it only takes a couple of hours. They will comment on your Ticket 
that your configuration has been prepared.

## Preparing the data 

There are a few requirements that need to be fullfilled by your projects in order to successfully upload your artifacts.
A detailed description for the requirements can be found on the [Sonatype documentation](http://central.sonatype.org/pages/requirements.html).
Most of the information, *javadoc* and *source attachment*, the *gpg-plugin*, and  *distributionManagement* , which is described in this article is already included in freme-parent. 
So if you build a FREME-project that inherits from freme-parent it will not be necessary to specify that information again.


* Provide Javadoc and Source archives. You can use the [Maven javadoc-plugin](http://maven.apache.org/plugins/maven-javadoc-plugin/) and the [Maven source-plugin](https://maven.apache.org/plugins/maven-source-plugin/usage.html). 
Whenever Java 8 detects malformed Javadoc it will throw an Error, and not only Warnings as it used to be in earlier versions, 
which will make the build fail. This can be avoided by adding the following configuration to the maven-javadoc-plugin in the .pom file:
  
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-javadoc-plugin</artifactId>
    <version>2.9.1</version>
    <executions>
        <execution>
            <id>attach-javadocs</id>
            <goals>
                <goal>jar</goal>
            </goals>
            <configuration>
                <additionalparam>-Xdoclint:none</additionalparam>
            </configuration>
        </execution>
    </executions>
</plugin>
```
						
* Your files need to be signed with a GPG/PGP signature which has to be provided for each file by a **.asc** file 
containing the signature. After the configuration of the keys, as described in the [PGP Signature article](http://central.sonatype.org/pages/working-with-pgp-signatures.html)
in the Sonatype documentation, this can be done with the [maven-gpg-plugin](http://maven.apache.org/plugins/maven-gpg-plugin/usage.html).

* The project's **pom** file must contain the following information
    * groupId - The one you specified when signing in. It specifies the namespace that you own and to which your
     artifacts are uploaded. You can add subfolders by appending **.yoursubfolder** to the groupId in your **pom** file.
    * artifactId
    * version
    * packaging (only if it's not the default, i.e. *jar*)
    * name 
    * description
    * url (e.g. 'https://github.com/freme-project')
* Provide License information. The FREME-project uses the [Maven License Plugin](http://code.mycila.com/license-maven-plugin/). 
* Provide Developpers information 
    
```xml
<developers>  
  <developer>  
    <name>Jan Nehring</name>  
        <email>jan.nehring@dfki.de</email>  
        <organization>DFKI</organization>  
        <organizationUrl>http://www.dfki.de</organizationUrl>  
  </developer>  
</developers>
```
* Provide information about the Source Control System (SCM). The following example shows the information for the freme-parent project.
    
```xml
<scm>
    <connection>scm:git:git@github.com:freme-project/freme-parent.git</connection>
    <url>scm:git:git@github.com/freme-project:freme-parent.git</url>
    <developerConnection>scm:git:git@github.com:freme-project/freme-parent.git</developerConnection>
</scm>
```
* It is not recommended to use `` <repositories/></repositories> `` and `` <pluginRepositories></pluginRepositories> `` but publish **all** 
required components to the Central Repository


## Deployment

In order to deploy to the Central Repository, the correct configuration needs to be added to the project's **pom** file.

````xml
<distributionManagement>
    <snapshotRepository>
        <id>ossrh</id>
        <url>https://oss.sonatype.org/content/repositories/snapshots</url>
    </snapshotRepository>
    <repository>
        <id>ossrh</id>
        <url>https://oss.sonatype.org/service/local/staging/deploy/maven2/</url>
    </repository>
</distributionManagement>
````

The ```` <id> ```` must be identical to the ```` <id> ```` specified in your **settings.xml** file which is stored or 
needs to be created directly inside your maven folder, e.g. **~/.m2/**. The file should contain the following 
information:

````xml
<settings>
  <servers>
    <server>
      <id>ossrh</id>
      <username>your-jira-sonatype-username</username>
      <password>your-jira-sonatype-password</password>
    </server>
  </servers>
</settings>
````

You can upload SNAPSHOT-versions of your project, but they will not be synchronized with the Central Repository and your
projects do not necessarily have to fulfill the requirements mentioned above.
Deployment is done with the following Maven command: **mvn deploy:deploy**. In the Sonatype documentation you will
find a [detailed article](http://central.sonatype.org/pages/apache-maven.html) about the Deployment with Apache Maven.

When your maven build was successfull, you will find your project in the [Nexus Repository Manager](https://oss.sonatype.org/#stagingRepositories)
under **Staging Repositories**. Now you have to close the Repository with the close icon on top which will trigger 
automatic checks that verify if your project fulfills all requirements. If it does, you can release it by clicking on 
the release icon on top. Otherwise you will have to drop the project, fix the problems and do it again. When you 
finished this for the first time, you have to comment again on the JIRA Ticket created in the beginning that you promoted your first 
release. 
In order to see if your project is available now in the Central Repository, browse its contents on the
[Central Repository Website](https://search.maven.org/). It can take up to 2 hous until it will be available there.

## Release
This paragraph explains how to configure a project for automatic deployment to Maven Central when performing a Release. 

TODO
To be added when all Freme artifacts are successfully uploaded to Maven Central.
describe profile here (link to this part from preparing the data)



## Permissions for your namespace in the Central Repository

The owner of the namespace can request to add people to the list of developpers that are allowed to publish artifacts
to your namespace. Just comment again in the same JIRA issue that was used in the beginning to request your namespace.
Also comment that issue when you want make some one else the owner of your namespace. 

