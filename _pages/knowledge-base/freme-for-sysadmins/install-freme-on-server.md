---
layout: page
title: Running FREME on a webserver
dropdown: Knowledge Base, FREME for System Administrators
pos: 4.17
---
# Running FREME on a webserver

This guide explains how to install FREME on a web server.

## Pre requisites

* A server that meets the [FREME hardware requirements](freme-hardware-requirements.html) and has a Linux operating system installed. FREME works on other operating systems also but this guide targets Linux servers.
* Java 8 or higher installed on the web server
* A FREME package. See [Creating and running a FREME package](creating-and-running-a-freme-package.html) for more information.
* Depending on the services you use you might need to have a MySQL webserver installed. FREME can also be configured to run with other databases, so MySQL is not obligatory. See [configuration options](http://api-dev.freme-project.eu/doc/knowledge-base/freme-for-sysadmins/configuration-options.html) for more information on how to configure the database.

## Installation procedure

* Copy the freme package to the installation folder, e.g. to /opt/freme
* Make scripts executable: chmod +x /opt/freme/bin/*
* Start FREME: /opt/freme/bin/start_server.sh
* Check logfiles to see if everything works fine: tail -f /opt/freme/logs/broker.log
* Stop FREME: /opt/freme/bin/stop_server.sh

### Creating a start / stop script

You can copy the script from /opt/freme/bin/server_start_script.sh to /etc/init.d/freme . You need to edit the script and change the variable FREME_DIR to point to your FREME installation folder. Then you can start, restart and stop FREME using these commands:

```
service freme start
service freme restart
service freme stop
```

## Tips

### Prevent loosing connection to MySQL database

We had the issue that the connection to the MySQL database gets lost when FREME is idle for some hours. This problem can be overcome by adding these parameters to application.properties:

```
spring.datasource.testOnBorrow=true
spring.datasource.validationQuery=SELECT 1
```

### FREME hangs during startup

On ubuntu servers we observed the problem that sometimes FREME freezes during startup. The last log message before the freeze is "Mapping servlet: 'dispatcherServlet' to [/]" or "create new admin user". This can be a problem with the secure random number generator. You can overcome this problem by starting FREME with this command line option:

```
-Djava.security.egd=file:/dev/./urandom
```

E.g. through creating a configuration file "start-properties" with this content:

```
START_ARGS="-Djava.security.egd=file:/dev/./urandom"
```
