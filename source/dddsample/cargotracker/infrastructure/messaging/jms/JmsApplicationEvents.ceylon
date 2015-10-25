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

import javax.annotation {
	resource=resource__SETTER
}
import javax.inject {
	inject=inject__SETTER
}
import javax.jms {
	JMSContext,
	Destination
}

import org.slf4j {
	Logger
}
import javax.enterprise.context {

	applicationScoped
}
applicationScoped
shared class JmsApplicationEvents() satisfies ApplicationEvents{
	
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
	
	shared actual void cargoHasArrived(Cargo cargo) {}
	
	shared actual void cargoWasHandled(HandlingEvent event) {}
	
	shared actual void cargoWasMisdirected(Cargo cargo) {}
	
	shared actual void receivedHandlingEventRegistrationAttempt(HandlingEventRegistrationAttempt attempt) {}
	
}