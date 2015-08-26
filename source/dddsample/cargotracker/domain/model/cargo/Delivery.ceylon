


import dddsample.cargotracker.domain.infrastructure.persistence.jpa {
	TransportStatusConverter,
	RoutingStatusConverter
}
import dddsample.cargotracker.domain.model.handling {
	HandlingHistory,
	HandlingEvent,
	load,
	unload,
	receive,
	customs,
	claim
}
import dddsample.cargotracker.domain.model.location {
	Location
}
import dddsample.cargotracker.domain.model.voyage {
	Voyage
}

import javax.persistence {
	embeddable,
	convert=convert__FIELD,
	column=column__FIELD,
	manyToOne=manyToOne__FIELD,
	joinColumn=joinColumn__FIELD,
	embedded=embedded__FIELD
}


embeddable
shared class Delivery {
	
	convert{converter = `TransportStatusConverter`;}
	column{name = "transport_status";}
	shared TransportStatus transportStatus;
	
	manyToOne
	joinColumn{name = "last_known_location_id";}
	variable Location? _lastKnownLocation;
	
	manyToOne
	joinColumn{name = "current_voyage_id";}
	variable Voyage? _currentVoyage;
	
	//embedded
	//HandlingActivity nextExpectedActivity;
	
	convert{converter = `RoutingStatusConverter`;}
	column{name = "routing_status";} 
	shared RoutingStatus routingStatus;
	
	manyToOne
	joinColumn{name = "last_event_id";} 
	variable HandlingEvent? lastEvent;
	
	RoutingStatus calculateRoutingStatus(Itinerary itinerary, RouteSpecification routeSpecification) 
			=> switch(itinerary) 
				case(Itinerary.empty) not_routed 
				else not_routed;
	 
	
	TransportStatus calculateTransportStatus(HandlingEvent? lastEvent) 
			=> if(exists lastEvent) then (switch(lastEvent.type) 
						case(load) onboard_carrier
						case(unload | receive | customs) in_port
						case(claim) claimed
				)
				else not_received;
				
	HandlingActivity calculateNextExpectedActivity(
            RouteSpecification routeSpecification, Itinerary itinerary){
		// TODO : temporary	!!!!!!!!!!!!!!!!!!!!!!!!!!!!		
		return HandlingActivity.init(customs,Location.unknown);
	}
	
	shared new init(HandlingEvent? lastEvent, Itinerary itinerary, RouteSpecification routeSpecification){
		this.lastEvent = lastEvent;
		this.routingStatus = calculateRoutingStatus(itinerary,routeSpecification);
		this.transportStatus = calculateTransportStatus(lastEvent);
		this._lastKnownLocation = lastEvent?.location;
		this._currentVoyage = if(transportStatus == onboard_carrier, exists lastEvent) then lastEvent.voyage else null;
		//this.nextExpectedActivity = calculateNextExpectedActivity(routeSpecification, itinerary);
	}
	
	shared new () extends init(HandlingEvent(), Itinerary(), RouteSpecification()){}
	
	
	shared new derivedFrom(RouteSpecification routeSpecification,Itinerary itinerary, HandlingHistory handlingHistory)
			extends init(handlingHistory.mostRecentlyCompletedEvent, itinerary, routeSpecification){}
	
	shared Location lastKnownLocation => _lastKnownLocation else Location.unknown;
	assign lastKnownLocation { _lastKnownLocation = lastKnownLocation; }
	
	shared Voyage currentVoyage => _currentVoyage else Voyage.none;
	assign currentVoyage { _currentVoyage = currentVoyage; }
	

	
}
