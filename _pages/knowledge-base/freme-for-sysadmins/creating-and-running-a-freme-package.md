---
layout: page
title: Creating and Running a FREME Package
dropdown: Knowledge Base, FREME for System Administrators
pos: 4.14
---

# Creating and Running a FREME Package

This article will guide you through the process of creating a FREME package, creating a binary distribution and running that package.

## Prerequisites

This guide is platform independent and works on Linux, Windows and Mac environments. This is intendet for Linux environment and the terminal commands may differ on other operating systems. You need to have the following software installed:

* Java (version 8 or higher)
* Maven (version 3.0.5 or higher)

## Create the package

### File and folder structure

A FREME package consists of at least these files

* pom.xml
* src/main/resources/package.xml

Usually there are some more configuration files, e.g.

* src/main/resources/application.properties
* src/main/resources/log4j.properties

### pom.xml

FREME uses Maven as build system. The pom.xml file of a FREME package specifies the maven artifacts that should be pulled in as dependencies. This is the code for a FREME packages pom.xml file:

```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <parent>
    <groupId>eu.freme.packages</groupId>
    <artifactId>package-parent</artifactId>
    <version>0.1-SNAPSHOT</version>
  </parent>

  <artifactId>broker-dev</artifactId>
	<repositories>
		<repository>
			<id>freme-release</id>
			<name>freme-nexus</name>
			<url>http://rv1443.1blu.de/nexus/content/repositories/releases/</url>
			<snapshots>
				<enabled>false</enabled>
			</snapshots>
		</repository>
		<repository>
			<id>freme-nexus</id>
			<name>freme-nexus</name>
			<url>http://rv1443.1blu.de/nexus/content/repositories/snapshots/</url>
			<releases>
				<enabled>false</enabled>
			</releases>
		</repository>
	</repositories>

	<dependencies>
		<dependency>
			<groupId>eu.freme.bservices</groupId>
			<artifactId>user-controller</artifactId>
			<version>0.2-SNAPSHOT</version>
		</dependency>
		<dependency>
			<groupId>eu.freme.e-services</groupId>
			<artifactId>tilde-services</artifactId>
			<version>0.1-SNAPSHOT</version>
		</dependency>
		<dependency>
			<groupId>eu.freme.bservices</groupId>
			<artifactId>package-maker</artifactId>
			<version>0.2-SNAPSHOT</version>
		</dependency>
	</dependencies>

</project>
```

It derives from eu.freme.packages.package-parent. Further it defines the FREME maven repositories so it knows where to download the Maven artifacts. Further it defines a set of dependencies on FREME b-Services and e-Services. When you create your own FREME package you only have to modify the dependencies. It is important to specify the dependency to `eu.freme.bservices.package-maker` for the step "Create binary distribution" of this tutorial.

### package.xml

The package.xml specifies which b-Services and e-Services should start when the package is started. These services have to be specified as dependencies before they can be started. It is a Spring XML configuration file. In the FREME use case the syntax is reduced so it only uses import directives. This example shows an example of a package.xml:

```
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
	http://www.springframework.org/schema/beans/spring-beans.xsd
	http://www.springframework.org/schema/context
	http://www.springframework.org/schema/context/spring-context.xsd">

	<import resource="classpath:spring-configurations/freme-common.xml" />
	<import resource="classpath:spring-configurations/user-controller.xml" />
	<import resource="classpath:spring-configurations/tilde-translation.xml" />
</beans>
```

Most of this example is boilerplate code. The interesting part are the three lines starting with `<import`. Three XML configurations are imported into the package. First FREMECommon is loaded which is necessary for every FREME package. Then it loads the user controller and the Tilde ETranslation service.

### Additional configuration files

Typically a FREME package has more configuration files.

* log4j.properties is used to configure the logging behaviour.
* application.properties is a standard Java properties file for configuration settings.

## Running the package

This section will guide the reader through creating a binary distribution out of the FREME package and start the server.

### Create binary distribution

In a terminal navigate to the folder of the FREME package and type

```
mvn package
```

This will create the binary distribution. It will reside in `target/freme-distribution-assembly/freme-distribution/`. You can copy this folder to any location or server.
In order to run it you should make the scripts in the `bin` folder executable:

```
chmod +x bin/*.sh
```

### Starting the server

*From the command line*

In the terminal navigate to the folder of the binary distribution and start the server:

```
cd target/freme-package
bin/start_local.sh
```

The server is ready when you see the message "FREMEStarter: Started FREMEStarter in ... seconds"

### Doing the first API call

From another terminal, use cURL to perform your first API call:

```
curl -X POST "http://localhost:8080/e-translation/tilde?source-lang=en&target-lang=de&informat=text&input=Hello+World"
```
