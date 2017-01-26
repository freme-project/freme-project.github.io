---
layout: page
title: Creating and Running a FREME Package
dropdown: Knowledge Base, FREME for System Administrators
pos: 4.14
---

# Creating and Running a FREME Package

This article will guide you through the process of creating a FREME package, creating a binary distribution and running that package. All the source code of this guide resides on GitHub. Check out the [freme-examples](https://github.com/freme-project/freme-examples) repository and have a look at the module **broker-simple**.

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
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>package-parent</artifactId>
        <groupId>eu.freme.packages</groupId>
        <version>0.2</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>

    <artifactId>broker-simple</artifactId>
    <version>0.1-SNAPSHOT</version>

    <dependencies>
        <dependency>
            <groupId>eu.freme.bservices.controllers</groupId>
            <artifactId>users</artifactId>
            <version>0.2</version>
        </dependency>
        <dependency>
            <groupId>eu.freme.e-services</groupId>
            <artifactId>tilde-services</artifactId>
            <version>0.3</version>
        </dependency>
    </dependencies>

</project>
```

It derives from eu.freme.packages.package-parent. This includes the dependency `eu.freme.bservices.package-maker` which is important for the step "Create binary distribution" of this tutorial. Further it defines the FREME maven repositories so it knows where to download the Maven artifacts. Further it defines a set of dependencies on FREME b-Services and e-Services. When you create your own FREME package you only have to modify the dependencies.

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
    <import resource="classpath:spring-configurations/users.xml" />
    <import resource="classpath:spring-configurations/tilde-translation.xml" />
</beans>
```

Most of this example is boilerplate code. The interesting part are the three lines starting with `<import`. Three XML configurations are imported into the package. First FREMECommon is loaded which is necessary for every FREME package. Then it loads the user controller and the Tilde ETranslation service.

### Additional configuration files

Typically a FREME package has more configuration files.

* log4j.properties is used to configure the logging behaviour.
* application.properties is a standard Java properties file for configuration settings.
* start-properties contains command line arguments that will be added to the JVM when the program is started. Here you can e.g. configure additional memory to the program:

```
START_ARGS="-Xmx16G -Djava.security.egd=file:/dev/./urandom"
```

This configures 16GB of RAM for the program. The second option configures a specific random number generator. This significantly speeds up FREMEs startup time and we advice to always use this option.

## Running the package

This section will guide the reader through creating a binary distribution out of the FREME package and start the server.

### Create binary distribution

In a terminal navigate to the folder of the FREME package and type

```
mvn package
```

This will create the binary distribution. It will reside in `target/freme-package/`. You can copy this folder to any location or server.
In order to run it you should make the scripts in the `bin` folder executable:

```
cd target/freme-package
chmod +x bin/*.sh
```

### Starting the server

*From the command line*

In the terminal navigate to the folder of the binary distribution and start the server:

```
bin/start_local.sh
```

The server is ready when you see the message "FREMEStarter: Started FREMEStarter in ... seconds"

The script does not work for mac users. Mac users should cd to the location of the FREME package and execute this shell command:

```
java -cp "./*:config" org.springframework.boot.loader.JarLauncher
```

### Doing the first API call

From another terminal, use cURL to perform your first API call:

```
curl -X POST "http://localhost:8080/e-translation/tilde?source-lang=en&target-lang=de&informat=text&input=Hello+World"
```
