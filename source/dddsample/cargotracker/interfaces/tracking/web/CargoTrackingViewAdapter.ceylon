import ceylon.collection {
	ArrayList
}
import ceylon.interop.java {
	JavaList
}
import ceylon.language.meta {
	metatype=type
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
	HandlingEvent,
	load,
	unload,
	HandlingEventTypeProhibitedVoyage,
	HandlingEventTypeRequiredVoyage,
	receive,
	claim,
	customs
}
import dddsample.cargotracker.domain.model.voyage {
	Voyage
}

import java.text {
	SimpleDateFormat
}
import java.util {
	JList=List,
	Date
}
shared class CargoTrackingViewAdapter(Cargo cargo, List<HandlingEvent> handlingEvents) {
	
	String formatDate(Date d) => SimpleDateFormat("MM/dd/yyyy hh:mm a z").format(d);
	
	shared JList<HandlingEventViewAdapter> events => let(adapters = handlingEvents.map(HandlingEventViewAdapter)) 
													 JavaList(ArrayList{*adapters});
	
	
	shared String trackingId => cargo.trackingId.idString;
	shared String origin => cargo.origin.name;
	shared String destination => cargo.routeSpecification.destination.name;
	shared String statusText => let(delivery = cargo.delivery) (
								switch(delivery.transportStatus)
									case(in_port) "In port ``delivery.lastKnownLocation.name``"
									// TODO : remove 'else nothing'
									case(onboard_carrier) "Onboard voyage ``delivery.currentVoyage?.voyageNumber?.number else nothing``"
									case(claimed) "Claimed"
									case(not_received) "Not received"
									case(unknown) "Unknown"
								);

	
	shared String  nextExpectedActivity 
			=>  if(exists activity = cargo.delivery.nextExpectedActivity)
				then
					let(type = activity.type)
					let(text = "Next expected activity is to ``metatype(activity.type).declaration.name``")
					let(voyageNumber = activity.voyage?.voyageNumber?.number else "") // TODO yuck, remove 'else ""' here 
					(switch(type)
						case(load) "``text`` cargo onto voyage ``voyageNumber`` in ``activity.location.name``"
						case(unload) "``text`` cargo off of ``voyageNumber`` in ``activity.location.name``"
						else "``text`` cargo in ``activity.location.name``"
					)
				else "";
		
	shared Boolean misdirected => cargo.delivery.misdirected;
	shared String eta => if(exists eta = cargo.delivery.estimatedTimeOfArrival) 
						 then formatDate(eta)
						 else "?";
	
	shared class HandlingEventViewAdapter(HandlingEvent handlingEvent){
		
		shared Boolean expected => cargo.itinerary?.isExpected(handlingEvent) else nothing; // TODO remove 'else nothing'
		shared String description 
				=> switch(typeAndVoyage = handlingEvent.typeAndVoyage)
					case(is  [HandlingEventTypeRequiredVoyage, Voyage]) let([type,voyage] = typeAndVoyage) 
						(switch(type)
						 case(load) "Loaded onto voyage ``voyage.voyageNumber.number``
			 	                     in ``handlingEvent.location.name``, at ``formatDate(handlingEvent.completionTime)`` 
			 	                    "
						 case(unload) "Unloaded off voyage ``voyage.voyageNumber.number``
			 	                       in ``handlingEvent.location.name``, at ``formatDate(handlingEvent.completionTime)`` 
			 	                      "
						)
					case(is HandlingEventTypeProhibitedVoyage) let(type = typeAndVoyage) 
						(switch(type)
						case(receive) "Received in ``handlingEvent.location.name``, at ``formatDate(handlingEvent.completionTime)``"
						case(claim) "Claimed in ``handlingEvent.location.name``, at ``formatDate(handlingEvent.completionTime)``"
						case(customs) "Cleared customs in ``handlingEvent.location.name``, at ``formatDate(handlingEvent.completionTime)``"
						);
				
	}
	
}

