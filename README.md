# DDDSample for Ceylon and Java EE

This project is a rewrite in Ceylon of this [Java EE port][]
of the [original Spring DDDSample][] project.

Java EE technologies used include JPA, CDI, EJB, JAX-RS, JMS,
JSF, and Facelets.

[Java EE port]: https://java.net/projects/cargotracker/pages/Home
[original Spring DDDSample]: http://dddsample.sourceforge.net/

## Requirements

This project requires [Ceylon 1.3.1][] and [WildFly 10.1][].

[Ceylon 1.3.1]: https://ceylon-lang.org/download
[WildFly 10.1]: http://wildfly.org/

### Compiling and assembling

In the root directory of this project, compile the Ceylon 
source code:

    ceylon compile

Next, assemble the Java EE web application:

    ceylon war dddsample -R webapp --static-metamodel

The web application archive `dddsample-1.0.0.war` is created at 
the root of the project.

### Deploying and running

To deploy the web application archive to WildFly, first copy
the `.war` file to the directory:
   
    wildfly-10.1.0.Final/standalone/deployments
    
Then start WildFly with the command:

    wildfly-10.1.0.Final/bin/standalone.sh -c standalone-full.xml
  
You must explicitly specify the *full* configuration because 
this project uses JMS 2.0 which is not available in the default 
configuration of Wildfly.

The JPA persistence unit for the application uses the default 
in memory database that comes preconfigured in WildFly 
(`java:jboss/datasources/ExampleDS`).

## Try it

To test the application:

* go to <http://localhost:8080/dddsample-1.0.0/>,
* click on the *public landing page* link,
* type a cargo name, as suggested, in the search box, and 
  then
* try other links in the header of the page.
