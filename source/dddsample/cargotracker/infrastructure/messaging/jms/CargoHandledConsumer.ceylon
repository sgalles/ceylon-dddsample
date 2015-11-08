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
	inject=inject__FIELD
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

messageDriven{ activationConfig = {
	activationConfigProperty{
		propertyName = "destinationType"; 
		propertyValue = "javax.jms.Queue";},
		activationConfigProperty{
			propertyName = "destinationLookup"; 
			propertyValue = "java:global/jms/CargoHandledQueue";}
		};
		messageListenerInterface=`MessageListener`;
	}
shared class CargoHandledConsumer() satisfies MessageListener{
	
	inject
	late CargoInspectionService cargoInspectionService;
	
	inject
	late Logger logger;
	
	shared actual default void onMessage(Message message) {
		try {
			assert(is TextMessage message);
			String trackingIdString = message.text;
			
			cargoInspectionService.inspectCargo(TrackingId(trackingIdString));
		} catch (JMSException e) {
			logger.error("Error procesing JMS message", e);
		}
	}
	
}