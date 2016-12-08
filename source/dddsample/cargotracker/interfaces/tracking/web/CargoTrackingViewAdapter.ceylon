import ceylon.language.meta {
    metatype=type
}

import dddsample.cargotracker.domain.model.cargo {
    Cargo,
    TransportStatus
}
import dddsample.cargotracker.domain.model.handling {
    HandlingEvent,
    HandlingEventTypeProhibitedVoyage {
        ...
    },
    HandlingEventTypeRequiredVoyage {
        ...
    }
}
import dddsample.cargotracker.domain.model.voyage {
    Voyage
}

import java.text {
    SimpleDateFormat
}
import java.util {
    JList=List,
    Arrays
}

shared class CargoTrackingViewAdapter(Cargo cargo, List<HandlingEvent> handlingEvents) {
	
	value dateFormat => SimpleDateFormat("MM/dd/yyyy hh:mm a z");
	
	shared JList<HandlingEventViewAdapter> events
			=> Arrays.asList(*handlingEvents.map(HandlingEventViewAdapter));

	shared String trackingId => cargo.trackingId.idString;
	shared String origin => cargo.origin.name;
	shared String destination => cargo.routeSpecification.destination.name;

	shared String statusText {
	    value delivery = cargo.delivery;
	    return switch (delivery.transportStatus)
		case (TransportStatus.in_port)
			"In port ``delivery.lastKnownLocation.name``"
		// TODO : remove 'else nothing'
		case (TransportStatus.onboard_carrier)
			"Onboard voyage ``delivery.currentVoyage?.voyageNumber?.number else "???"``"
		case (TransportStatus.claimed)
			"Claimed"
		case (TransportStatus.not_received)
			"Not received"
		case (TransportStatus.unknown)
			"Unknown";
	}

	shared String nextExpectedActivity {
	    if (exists activity = cargo.delivery.nextExpectedActivity) {
			value type = activity.type;
			value text = "Next expected activity is to ``metatype(activity.type).declaration.name``";
			value voyageNumber = activity.voyage?.voyageNumber?.number else "";
	        return switch(type)
				case (load) "``text`` cargo onto voyage ``voyageNumber`` in ``activity.location.name``"
				case (unload) "``text`` cargo off of ``voyageNumber`` in ``activity.location.name``"
				else "``text`` cargo in ``activity.location.name``";
	    }
	    else {
	        return "";
	    }
	}
		
	shared Boolean misdirected => cargo.delivery.misdirected;
	shared String eta
			=> if (exists eta = cargo.delivery.estimatedTimeOfArrival)
			then dateFormat.format(eta)
			else "?";
	
	shared class HandlingEventViewAdapter(HandlingEvent handlingEvent) {

		shared Boolean expected
				=> cargo.itinerary?.isExpected(handlingEvent)
				else false;

		shared String description {
		    switch (typeAndVoyage = handlingEvent.typeAndVoyage)
			case ([HandlingEventTypeRequiredVoyage type, Voyage voyage]) {
				return switch (type)
				case (load)
					"Loaded onto voyage ``voyage.voyageNumber.number``
			 	     in ``handlingEvent.location.name``, at ``dateFormat.format(handlingEvent.completionTime)``
			 	    "
				case (unload)
					"Unloaded off voyage ``voyage.voyageNumber.number``
			 	     in ``handlingEvent.location.name``, at ``dateFormat.format(handlingEvent.completionTime)``
			 	    ";
			}
			case (is HandlingEventTypeProhibitedVoyage) {
				return switch(typeAndVoyage)
				case (receive)
					"Received in ``handlingEvent.location.name``, at ``dateFormat.format(handlingEvent.completionTime)``"
				case (claim)
					"Claimed in ``handlingEvent.location.name``, at ``dateFormat.format(handlingEvent.completionTime)``"
				case (customs)
					"Cleared customs in ``handlingEvent.location.name``, at ``dateFormat.format(handlingEvent.completionTime)``";
			}
		}
				
	}
	
}
