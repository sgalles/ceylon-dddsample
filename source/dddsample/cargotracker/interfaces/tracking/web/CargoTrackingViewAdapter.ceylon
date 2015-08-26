import ceylon.collection {
	ArrayList
}
import ceylon.interop.java {
	JavaList
}

import dddsample.cargotracker.domain.model.cargo {
	Cargo,
	in_port,
	onboard_carrier,
	claimed,
	not_received,
	unknown
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEvent
}

import java.util {
	JList=List
}
shared class CargoTrackingViewAdapter(Cargo cargo, List<HandlingEvent> handlingEvents) {
	
	
	shared JList<HandlingEventViewAdapter> events => let(adapters = handlingEvents.map(HandlingEventViewAdapter)) 
													 JavaList(ArrayList{*adapters});
	
	
	shared String trackingId => cargo.trackingId.idString;
	shared String origin => cargo.origin.name;
	shared String destination => cargo.routeSpecification.destination.name;
	shared String statusText => let(delivery = cargo.delivery) (
								switch(delivery.transportStatus)
									case(in_port) "In port ``delivery.lastKnownLocation.name``"
									case(onboard_carrier) "Onboard voyage ``delivery.currentVoyage.voyageNumber.idString``"
									case(claimed) "Claimed"
									case(not_received) "Not received"
									case(unknown) "Unknown"
								);

	
	shared String  nextExpectedActivity = "Cargo-nextExpectedActivity";
	shared Boolean misdirected = true;
	shared String eta = "CargoTrackingViewAdapter-eta";
	
}

shared class HandlingEventViewAdapter(HandlingEvent handlingEvent){
	
	shared Boolean expected = true;
	shared String description = "HandlingEventViewAdapter-description";
	
}