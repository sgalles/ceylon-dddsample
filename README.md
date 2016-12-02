#DDDSample for Ceylon / JEE

This project is a **Ceylon+JEE** port of this [Java+JEE](https://java.net/projects/cargotracker/pages/Home) 
port of the [original Java+Spring DDDSample](http://dddsample.sourceforge.net/) project

##Quickstart

###Build

You need a Ceylon 1.3.1 distribution available in your path.

At the root directory of
the project execute

* `ceylon compile`
* `ceylon war dddsample/1.0.0  -R webapp --static-metamodel`

The war file `dddsample-1.0.0.war` is created at the root of the project

###Deploy

The created war file can be deployed into [Wildfly 10.1](http://wildfly.org/).

* Copy the war at `wildfly-10.1.0.Final/standalone/deployments`
* Start Wildfly with the command   `wildfly-10.1.0.Final/bin/standalone.sh -c standalone-full.xml`
  
(you must explicitly use the *full* configuration because this project leverages JMS 2.0 that 
is not available in the default configuration of Wildfly).

The JPA persistent-unit of the application uses the default in memory database preconfigured in
Wildfly (`java:jboss/datasources/ExampleDS`). So this should work out of the box.

###Try it

* In your browser go to [http://localhost:8080/dddsample-1.0.0/](http://localhost:8080/dddsample-1.0.0/)
* click on the *public landing page* link
* type a cargo name, as suggested, in the search box
* try other links in the header of the page
