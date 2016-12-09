import javax.ejb {
    messageDriven,
    activationConfigProperty
}
import javax.inject {
    inject
}
import javax.jms {
    MessageListener,
    Message
}

import org.slf4j {
    Logger
}


messageDriven {
    activationConfig = {
        activationConfigProperty {
            propertyName = "destinationType";
            propertyValue = "javax.jms.Queue";
        },
        activationConfigProperty {
            propertyName = "destinationLookup";
            propertyValue = "java:global/jms/MisdirectedCargoQueue";
        }
    };
    messageListenerInterface = `interface MessageListener`;
}

shared class MisdirectedCargoConsumer() satisfies MessageListener{

    inject
    late Logger logger;

    shared actual void onMessage(Message message) {
        logger.info("Received JMS message: ``message``");
    }
}

messageDriven {
    activationConfig = {
        activationConfigProperty {
            propertyName = "destinationType";
            propertyValue = "javax.jms.Queue";
        },
        activationConfigProperty{
            propertyName = "destinationLookup";
            propertyValue = "java:global/jms/DeliveredCargoQueue";
        }
    };
    messageListenerInterface=`interface MessageListener`;
}
shared class DeliveredCargoConsumer() satisfies MessageListener{

    inject
    late Logger logger;

    shared actual void onMessage(Message message) {
        logger.info("Received JMS message: ``message``");
    }
}


