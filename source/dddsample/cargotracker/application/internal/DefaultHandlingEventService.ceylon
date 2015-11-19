import dddsample.cargotracker.application {
	HandlingEventService,
	ApplicationEvents
}
import dddsample.cargotracker.domain.model.cargo {
	TrackingId
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEventTypeBundle,
	HandlingEventRepository,
	HandlingEventFactory,
	HandlingEvent
}
import dddsample.cargotracker.domain.model.location {
	UnLocode
}
import dddsample.cargotracker.domain.model.voyage {
	VoyageNumber
}

import java.util {
	Date
}

import javax.ejb {
	stateless
}
import javax.inject {
	inject
}

import org.slf4j {
	Logger
}

stateless 
inject
shared class DefaultHandlingEventService(
	ApplicationEvents applicationEvents,
	HandlingEventRepository handlingEventRepository,
	HandlingEventFactory handlingEventFactory,
	Logger logger
) satisfies HandlingEventService {
	
	shared default actual void registerHandlingEvent(Date completionTime, TrackingId trackingId, HandlingEventTypeBundle<VoyageNumber> typeAndVoyageNumber, UnLocode unLocode) {
		Date registrationTime = Date();
		/* Using a factory to create a HandlingEvent (aggregate). This is where
		 it is determined wether the incoming data, the attempt, actually is capable
		 of representing a real handling event. */
		HandlingEvent event = handlingEventFactory.createHandlingEvent(
			registrationTime, completionTime, trackingId, unLocode, typeAndVoyageNumber);
		
		/* Store the new handling event, which updates the persistent
		 state of the handling event aggregate (but not the cargo aggregate -
		 that happens asynchronously!)
		 */
		handlingEventRepository.store(event);
		
		/* Publish an event stating that a cargo has been handled. */
		applicationEvents.cargoWasHandled(event);
		
		logger.info("Registered handling event");
	}
	
}