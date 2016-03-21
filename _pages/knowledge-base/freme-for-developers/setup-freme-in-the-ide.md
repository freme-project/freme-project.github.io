---
layout: page
title: Setup FREME in the IDE
dropdown: Knowledge Base, FREME for Developers
pos: 4.12
---

# Setting up FREME in the IDE

This guide helps software developers that want to do programming work using FREME to setup integrated development environments (IDE) such as Eclipse or Netbeans.

## Setup FREMECommon, b-Services or e-Services

First you clone the Git repositories from GitHub, e.g.

* FREMECommon: https://github.com/freme-project/FREMECommon.git
* Basic Services: https://github.com/freme-project/basic-services.git
* E-Services: https://github.com/freme-project/e-services.git

Of course implementations can also reside in other version control systems or other Git repositories.

After downloading the source codes you should setup a Maven project within your IDE. The rest should happen automatically.

FREMECommon, b-Services and e-Services are not standalone applications. Therefore it is not possible to run them as a Java application. These projects are usually run as unit tests. In order to run them as a standalone application, please create a FREME package that includes this module and run the FREME package as a standalone application.

## Setup a package as standalone application

FREME packages do not contain any source code. Therefore usually they are assemblied via maven and run from outside the IDE. But you might want to start them from within the IDE in order to run your b-Service or e-Service as a normal Java application instead of as a unit test only.

In order to configure a FREME package from within your IDE you usually acquire the source codes first, e.g. through cloning the FREME packages Git repository at https://github.com/freme-project/freme-packages.git. Then you start it like any other Java application with main class `eu.freme.common.starter.FREMEStarter`. It will look for configuration files like `package.xml` and `application.properties` in the root of the classpath which is `src/main/resources` in the IDE.