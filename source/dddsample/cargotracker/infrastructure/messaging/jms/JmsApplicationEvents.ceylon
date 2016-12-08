import dddsample.cargotracker.application {
    ApplicationEvents
}
import dddsample.cargotracker.domain.model.cargo {
    Cargo
}
import dddsample.cargotracker.domain.model.handling {
    HandlingEvent
}
import dddsample.cargotracker.interfaces.handling {
    HandlingEventRegistrationAttempt
}

import java.io {
    Serializable
}

import javax.annotation {
    resource
}
import javax.enterprise.context {
    applicationScoped
}
import javax.inject {
    inject
}
import javax.jms {
    JMSContext,
    Destination
}

import org.slf4j {
    Logger
}

Integer lowPriority = 0;

applicationScoped
shared class JmsApplicationEvents() satisfies ApplicationEvents {
	
	inject
	late JMSContext jmsContext;
	resource{lookup = "java:global/jms/CargoHandledQueue";}
	late Destination cargoHandledQueue;
	resource{lookup = "java:global/jms/MisdirectedCargoQueue";}
	late Destination misdirectedCargoQueue;
	resource{lookup = "java:global/jms/DeliveredCargoQueue";}
	late Destination deliveredCargoQueue;
	resource{lookup = "java:global/jms/HandlingEventRegistrationAttemptQueue";}
	late Destination handlingEventQueue;
	inject
	late Logger logger;
	
	shared actual void cargoWasHandled(HandlingEvent event) {
		Cargo cargo = event.cargo;
		logger.info("Cargo was handled ``cargo``");
		jmsContext.createProducer()
				.setPriority(lowPriority)
				.setDisableMessageID(true)
				.setDisableMessageTimestamp(true)
				.send(cargoHandledQueue,
			cargo.trackingId.idString);
	}
	
	shared actual void cargoWasMisdirected(Cargo cargo) {
		logger.info("Cargo was misdirected ``cargo``");
		jmsContext.createProducer()
				.setPriority(lowPriority)
				.setDisableMessageID(true)
				.setDisableMessageTimestamp(true)
				.send(misdirectedCargoQueue,
			cargo.trackingId.idString);
	}
	
	shared actual void cargoHasArrived(Cargo cargo) {
		logger.info("Cargo has arrived ``cargo``");
		jmsContext.createProducer()
				.setPriority(lowPriority)
				.setDisableMessageID(true)
				.setDisableMessageTimestamp(true)
				.send(deliveredCargoQueue,
			cargo.trackingId.idString);
	}
	
	shared actual void receivedHandlingEventRegistrationAttempt(
		HandlingEventRegistrationAttempt attempt) {
		logger.info("Received handling event registration attempt ``attempt``");
		assert(is Serializable serializableAttempt = attempt);
		jmsContext.createProducer()
				.setPriority(lowPriority)
				.setDisableMessageID(true)
				.setDisableMessageTimestamp(true)
				.send(handlingEventQueue, serializableAttempt of Serializable);
	}
	
}