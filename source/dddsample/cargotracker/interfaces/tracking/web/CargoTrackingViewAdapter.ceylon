import ceylon.collection {
	ArrayList
}
import ceylon.interop.java {
	JavaList
}

import dddsample.cargotracker.domain.model.cargo {
	Cargo
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEvent
}

import java.util {
	JList=List
}
shared class CargoTrackingViewAdapter(Cargo cargo, List<HandlingEvent> handlingEvents) {
	
	
	//public String getTrackingId() {
	//	return cargo.getTrackingId().getIdString();
	//}
	//
	//public String getOrigin() {
	//	return getDisplayText(cargo.getOrigin());
	//}
	//
	//public String getDestination() {
	//	return getDisplayText(cargo.getRouteSpecification().getDestination());
	//}
	//shared String trackingId => cargo.trackingId.idString;
	
	shared String trackingId = "CargoTrackingViewAdapter-trackingId";
	shared String origin = "CargoTrackingViewAdapter-origin";
	shared String destination = "CargoTrackingViewAdapter-destination";
	shared String statusText = "Cargo-statusText";
	shared String  nextExpectedActivity = "Cargo-nextExpectedActivity";
	shared Boolean misdirected = true;
	shared String eta = "CargoTrackingViewAdapter-eta";
	
	List<HandlingEventViewAdapter> _events = ArrayList { HandlingEventViewAdapter(HandlingEvent()), HandlingEventViewAdapter(HandlingEvent())};
	shared JList<HandlingEventViewAdapter> events => JavaList(_events);
	
}

shared class HandlingEventViewAdapter(HandlingEvent handlingEvent){
	
	shared Boolean expected = true;
	shared String description = "HandlingEventViewAdapter-description";
	
}