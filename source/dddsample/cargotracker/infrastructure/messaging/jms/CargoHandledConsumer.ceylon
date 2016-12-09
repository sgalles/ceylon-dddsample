import dddsample.cargotracker.application {
    CargoInspectionService
}
import dddsample.cargotracker.domain.model.cargo {
    TrackingId
}

import javax.ejb {
    messageDriven,
    activationConfigProperty
}
import javax.inject {
    inject
}
import javax.jms {
    MessageListener,
    TextMessage,
    JMSException,
    Message
}

import org.slf4j {
    Logger
}

messageDriven{
    activationConfig = {
        activationConfigProperty {
            propertyName = "destinationType";
            propertyValue = "javax.jms.Queue";
        },
        activationConfigProperty {
            propertyName = "destinationLookup";
            propertyValue = "java:global/jms/CargoHandledQueue";
        }
    };
    messageListenerInterface = `interface MessageListener`;
}
shared class CargoHandledConsumer() satisfies MessageListener{

    inject
    late CargoInspectionService cargoInspectionService;

    inject
    late Logger logger;

    shared actual void onMessage(Message message) {
        try {
            assert (is TextMessage message);
            cargoInspectionService.inspectCargo(TrackingId(message.text));
        } catch (JMSException e) {
            logger.error("Error procesing JMS message", e);
        }
    }

}