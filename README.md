#DDDSample for Ceylon / JEE

This project is a **Ceylon+JEE** port of this [Java+JEE](https://java.net/projects/cargotracker/pages/Home) 
port of the [original Java+Spring DDDSample](http://dddsample.sourceforge.net/) project

##Quickstart

###Build

You need a Ceylon 1.2 distribution available in your path.

At the root directory of
the project execute

* `ceylon compile`
* `ceylon war dddsample/1.0.0  -R webapp`

The war file `dddsample-1.0.0.war` is created at the root of the project

###Deploy

The created war file can be deployed into [Wildfly 9](http://wildfly.org/) (other containers
could be supported in the futur). 

* Copy the war at `wildfly-9.0.0.Final/standalone/deployments`
* Start Wildfly with the command   `wildfly-9.0.0.Final/bin/standalone.sh -c standalone-full.xml`
  
(you must explicitly use the *full* configuration because this project leverages JMS 2.0 that 
is not available in the default configuration of Wildfly).

The JPA persistent-unit of the application uses the default in memory database preconfigured in
Wildfly 9 (`java:jboss/datasources/ExampleDS`). So this should work out of the box.

###Try it

* In your browser go to [http://localhost:8080/dddsample-1.0.0/](http://localhost:8080/dddsample-1.0.0/)
* click on the *public landing page* link
* type a cargo name, as suggested, in the search box
* try other links in the header of the page

###Misc

* the project uses a private Ceylon repository for the JEE modules that were not yet available in Herd.
* the project does not use the usual [initialization scheme](https://github.com/ceylon/ceylon-sdk/blob/master/source/com/redhat/ceylon/war/WarInitializer.java) 
of a Ceylon war. Instead, it uses a [modified version of this scheme](https://github.com/sgalles/ceylon-dddsample/blob/master/source/dddsample/CeylonInit.java)
that has dependencies on Wildfly-specific libraries (the initial scheme does not work when Ceylon code is executed too early during
the container startup phase). Instead of using a servlet initialization, this alternate scheme leverages a 
[CDI Extension](https://github.com/sgalles/ceylon-dddsample/blob/master/resource/dddsample/ROOT/META-INF/services/javax.enterprise.inject.spi.Extension).
