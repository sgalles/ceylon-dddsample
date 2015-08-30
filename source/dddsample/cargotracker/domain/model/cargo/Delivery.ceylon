


import dddsample.cargotracker.domain.infrastructure.persistence.jpa {
	TransportStatusConverter,
	RoutingStatusConverter
}
import dddsample.cargotracker.domain.model.cargo {
	HandlingActivity {
		no_activity
	}
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

import java.util {
	Date
}

import javax.persistence {
	embeddable,
	convert=convert__FIELD,
	column=column__FIELD,
	manyToOne=manyToOne__FIELD,
	joinColumn=joinColumn__FIELD,
	embedded=embedded__FIELD,
	TemporalType,
	temporal=temporal__FIELD
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
	
	temporal(TemporalType.\iDATE)
	Date? _eta;
	
	shared Boolean misdirected;
	
	embedded
	shared HandlingActivity nextExpectedActivity;
	
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
	
	
	
	Boolean _onTrack(RoutingStatus routingStatus, Boolean misdirected) 
			=> routingStatus == routed && !misdirected;
	
	Date? calculateEta(Itinerary itinerary,RoutingStatus routingStatus, Boolean misdirected) 
			=> if(_onTrack(routingStatus, misdirected)) then itinerary.finalArrivalDate() else null; 
	
	HandlingActivity calculateNextExpectedActivity(HandlingEvent? lastEvent, RouteSpecification routeSpecification, Itinerary itinerary, RoutingStatus routingStatus,Boolean misdirected) 
			=>	let(legs = itinerary.legs)
				if(!_onTrack(routingStatus, misdirected)) then no_activity
				else if(exists lastEvent) 
					 then (  switch(lastEvent.type) 
							 case(load) 
								let(searchedLeg = legs.find(
									(leg) => leg.loadLocation.sameIdentityAs(lastEvent.location)
								)) 
								if(exists leg = searchedLeg) 
								then HandlingActivity.init([unload, leg.voyage], leg.unloadLocation) 
								else no_activity
							 case(unload)
								if(nonempty legs) 
								then let(pairedLegs = legs.paired.sequence().withTrailing([legs.last,null])) 
									let([Leg,Leg?]? searchedPairedLeg = pairedLegs.find(
										(pairedLeg) => let(currentLeg = pairedLeg[0]) currentLeg.unloadLocation.sameIdentityAs(lastEvent.location)
									)) 
									if(exists [leg, nextLeg] = searchedPairedLeg) 
									then if(exists nextLeg) 
										 then HandlingActivity.init([load, nextLeg.voyage], nextLeg.loadLocation)  
										 else  HandlingActivity.init(claim, leg.unloadLocation)
									else no_activity
								else no_activity
							case(receive) nothing
							case(claim) nothing
							case(customs) nothing
					 )	
					else HandlingActivity.init(receive, routeSpecification.origin); 

	
	shared new init(HandlingEvent? lastEvent, Itinerary itinerary, RouteSpecification routeSpecification){
		
		Boolean calculateMisdirectionStatus() 
				=> if(exists lastEvent)  then !itinerary.isExpected(lastEvent) else false;
		
		this.lastEvent = lastEvent;
		this.routingStatus = calculateRoutingStatus(itinerary,routeSpecification);
		this.transportStatus = calculateTransportStatus(lastEvent);
		this._lastKnownLocation = lastEvent?.location;
		this._currentVoyage = if(transportStatus == onboard_carrier, exists lastEvent) then lastEvent.voyage else null;
		this.misdirected = calculateMisdirectionStatus();
		this._eta = calculateEta(itinerary, routingStatus, misdirected);
		this.nextExpectedActivity = calculateNextExpectedActivity(lastEvent, routeSpecification, itinerary, routingStatus, misdirected);
		
	}
	
	shared new () extends init(HandlingEvent(), Itinerary(), RouteSpecification()){}
	
	
	
	
	shared new derivedFrom(RouteSpecification routeSpecification,Itinerary itinerary, HandlingHistory handlingHistory)
			extends init(handlingHistory.mostRecentlyCompletedEvent, itinerary, routeSpecification){}
	
	shared Boolean onTrack => _onTrack(routingStatus,misdirected);
	
	shared Location lastKnownLocation => _lastKnownLocation else Location.unknown;
	assign lastKnownLocation { _lastKnownLocation = lastKnownLocation; }
	
	shared Voyage currentVoyage => _currentVoyage else Voyage.none;
	assign currentVoyage { _currentVoyage = currentVoyage; }
	
	shared Date? estimatedTimeOfArrival => if(exists _eta) then Date(_eta.time) else null;
		

	
	
}
