import ceylon.collection {
	HashSet
}
import ceylon.json {
	Object
}

import dddsample.cargotracker.domain.model.cargo {
	Cargo
}
import dddsample.cargotracker.infrastructure.events.cdi {
	cargoInspected
}

import java.io {
	IOException
}

import javax.ejb {
	singleton,
	localBean
}
import javax.enterprise.event {
	observes
}
import javax.inject {
	inject=inject__FIELD
}
import javax.websocket {
	Session,
	onOpen,
	onClose
}
import javax.websocket.server {
	serverEndpoint
}

import org.slf4j {
	Logger
}
singleton
localBean
serverEndpoint("/tracking")
shared class RealtimeCargoTrackingService() {
	
	inject
	late Logger logger;
	
	value sessions = HashSet<Session>(); 
	
	onOpen
	shared void onOpen(Session session) {
		sessions.add(session);
	}
	
	onClose
	shared void onClose(Session session) {
		sessions.remove(session);
	}
	
	shared default void onCargoInspected(observes cargoInspected Cargo cargo) {
		logger.info("Received 'cargoInspected' event");
		String jsonValue = Object {
			"trackingId" -> cargo.trackingId.idString,
			"origin" -> cargo.origin.name,
			"destination" -> cargo.routeSpecification.destination.name,
			"lastKnownLocation" -> cargo.delivery.lastKnownLocation.name,
			"transportStatus" -> cargo.delivery.transportStatus.string
		}.string;
		
		for (session in sessions) {
			try {
				logger.info("Sending to websocket json : ``jsonValue``");
				session.basicRemote.sendText(jsonValue);
			} catch (IOException ex) {
				logger.warn("Unable to publish WebSocket message", ex);
			}
		}
	}
	
}