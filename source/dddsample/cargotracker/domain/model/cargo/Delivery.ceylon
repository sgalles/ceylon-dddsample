



import dddsample.cargotracker.domain.model.cargo {
	HandlingActivity
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
import dddsample.cargotracker.infrastructure.persistence.jpa {
	RoutingStatusConverter,
	TransportStatusConverter
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
	
	convert{converter = `class TransportStatusConverter`;}
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
	shared HandlingActivity? nextExpectedActivity;
	
	column{name = "unloaded_at_dest";}
	shared variable Boolean unloadedAtDestination;
	
	convert{converter = `class RoutingStatusConverter`;}
	column{name = "routing_status";} 
	shared RoutingStatus routingStatus;
	
	manyToOne
	joinColumn{name = "last_event_id";} 
	variable HandlingEvent? lastEvent;
	
	RoutingStatus calculateRoutingStatus(Itinerary? itinerary, RouteSpecification routeSpecification) 
			=> if(exists itinerary) 
				then if(routeSpecification.isSatisfiedBy(itinerary)) 
					 then routed 
					 else misrouted
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
	
	
	Date? calculateEta(Itinerary? itinerary,RoutingStatus routingStatus, Boolean misdirected) 
			=> if(_onTrack(routingStatus, misdirected)) then itinerary?.finalArrivalDate() else null; 
	
	HandlingActivity? calculateNextExpectedActivity(HandlingEvent? lastEvent, RouteSpecification routeSpecification, Itinerary? itinerary, RoutingStatus routingStatus,Boolean misdirected){
			if(!_onTrack(routingStatus, misdirected)) {
				return null;
			}	
			assert(exists itinerary); // TODO : this because _ontrack means there's an itinerary...try to improve to remove assert
		
			return	let(legs = itinerary.legs)
				if(!_onTrack(routingStatus, misdirected)) 
				then null
				else if(exists lastEvent) 
					 then (  switch(lastEvent.type) 
							 case(load) 
								let(searchedLeg = legs.find((leg) => leg.loadLocation.sameIdentityAs(lastEvent.location))) 
								if(exists leg = searchedLeg) 
								then HandlingActivity([unload, leg.voyage], leg.unloadLocation) 
								else null
							 case(unload)
								let(pairedLegs = legs.paired.sequence().withTrailing([legs.last,null])) 
								let([Leg,Leg?]? searchedPairedLeg = pairedLegs.find(
									(pairedLeg) => let(currentLeg = pairedLeg[0]) currentLeg.unloadLocation.sameIdentityAs(lastEvent.location)
								)) 
								if(exists [leg, nextLeg] = searchedPairedLeg) 
								then if(exists nextLeg) 
									 then HandlingActivity([load, nextLeg.voyage], nextLeg.loadLocation)  
									 else  HandlingActivity(claim, leg.unloadLocation)
								else null
							case(receive) 
								let(firstLeg = legs.first) 
								HandlingActivity([load, firstLeg.voyage], firstLeg.loadLocation)
							case(claim) null
							case(customs) null
					 )	
					else HandlingActivity(receive, routeSpecification.origin); 
		}

	Boolean calculateUnloadedAtDestination(HandlingEvent? lastEvent, RouteSpecification routeSpecification) 
			=> 	if(exists lastEvent) 
				then unload == lastEvent.type && routeSpecification.destination.sameIdentityAs(lastEvent.location)
				else false;
		
	
	shared new (HandlingEvent? lastEvent, Itinerary? itinerary, RouteSpecification routeSpecification){
		
		Boolean calculateMisdirectionStatus() 
				=> if(exists lastEvent,exists itinerary)  then !itinerary.isExpected(lastEvent) else false;
		
		this.lastEvent = lastEvent;
		this.routingStatus = calculateRoutingStatus(itinerary,routeSpecification);
		this.transportStatus = calculateTransportStatus(lastEvent);
		this._lastKnownLocation = lastEvent?.location;
		this._currentVoyage = if(transportStatus == onboard_carrier, exists lastEvent) then lastEvent.voyage else null;
		this.misdirected = calculateMisdirectionStatus();
		this._eta = calculateEta(itinerary, routingStatus, misdirected);
		this.nextExpectedActivity = calculateNextExpectedActivity(lastEvent, routeSpecification, itinerary, routingStatus, misdirected);
		this.unloadedAtDestination = calculateUnloadedAtDestination(lastEvent, routeSpecification);
	}
	

	
	shared new derivedFrom(RouteSpecification routeSpecification,Itinerary? itinerary, HandlingHistory handlingHistory)
			extends Delivery(handlingHistory.mostRecentlyCompletedEvent, itinerary, routeSpecification){}
	
	shared Boolean onTrack => _onTrack(routingStatus,misdirected);
	
	shared Location lastKnownLocation => _lastKnownLocation else Location.unknown;
	assign lastKnownLocation { _lastKnownLocation = lastKnownLocation; }
	
	shared Voyage? currentVoyage => _currentVoyage;
	assign currentVoyage { _currentVoyage = currentVoyage; }
	
	shared Date? estimatedTimeOfArrival => if(exists _eta) then Date(_eta.time) else null;
		
	shared Delivery updateOnRouting(RouteSpecification routeSpecification, Itinerary itinerary) 
		=> Delivery(this.lastEvent, itinerary, routeSpecification);
	
	
	
}
