


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

import javax.persistence {
	embeddable,
	convert=convert__FIELD,
	column=column__FIELD,
	manyToOne=manyToOne__FIELD,
	joinColumn=joinColumn__FIELD
}


embeddable
shared class Delivery {
	
	convert{converter = `TransportStatusConverter`;}
	column{name = "transport_status";}
	shared TransportStatus transportStatus;
	
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
			=> if(exists lastEvent) 
					then (switch(lastEvent.type) 
						case(load) onboard_carrier
						case(unload | receive | customs) in_port
						case(claim) claimed
				)
				else not_received;
	
	
	shared new init(HandlingEvent? lastEvent, Itinerary itinerary, RouteSpecification routeSpecification){
		this.lastEvent = lastEvent;
		this.routingStatus = calculateRoutingStatus(itinerary,routeSpecification);
		this.transportStatus = calculateTransportStatus(lastEvent);
		
	}
	
	shared new () extends init(HandlingEvent(), Itinerary(), RouteSpecification()){
		
	}
	
	
	shared new derivedFrom(RouteSpecification routeSpecification,Itinerary itinerary, HandlingHistory handlingHistory)
			extends init(null /* TODO !!!!! */, itinerary, routeSpecification){}
	

	
}
