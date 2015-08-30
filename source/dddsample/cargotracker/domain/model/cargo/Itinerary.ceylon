


import ceylon.interop.java {
	CeylonList
}

import dddsample.cargotracker.application.util {
	toJavaList
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEvent,
	receive,
	load,
	unload,
	claim,
	customs
}
import dddsample.cargotracker.domain.model.location {
	Location
}

import java.lang {
	Long
}
import java.util {
	Date,
	JList=List
}

import javax.persistence {
	CascadeType,
	embeddable,
	joinColumn=joinColumn__FIELD,
	oneToMany=oneToMany__FIELD
}

shared Date endOfDays = Date(Long.\iMAX_VALUE);

embeddable
shared class Itinerary {
	
	oneToMany{cascade = {CascadeType.\iALL}; orphanRemoval = true;}
	joinColumn{name = "cargo_id";}
	//orderBy("load_time") TODO reactivate when the problem with antlr lib in war is solved
	shared JList<Leg> _legs;
	
	shared new init({Leg*} legs){
		this._legs = toJavaList(legs);
	}
	
	shared new() extends init({}){}
	
	shared new empty extends init({}){}
	
	shared [Leg*] legs => CeylonList(_legs).sequence();
	
	shared Location initialDepartureLocation() 
			=> if(nonempty legs = legs) then legs.first.loadLocation else Location.unknown;	
	
	shared Location finalArrivalLocation() 
			=> if(nonempty legs = legs) then legs.last.unloadLocation else Location.unknown;	
	
	shared Date finalArrivalDate() 
			=> let(time = if(nonempty legs = legs) then legs.last.unloadTime.time else endOfDays.time)
			   Date(time);
	
	shared Boolean isExpected(HandlingEvent event) {
		
		Boolean sameVoyageAnd(Location(Leg) locating)(Leg leg)
			=> locating(leg).sameIdentityAs(event.location) && leg.voyage.sameIdentityAs(event.voyage);
		
		return if(nonempty legs = legs)
			then (switch(event.type)
				// Check that the first leg's origin is the event's location
				case(receive) legs.first.loadLocation == event.location 
				// Check that the there is one leg with same load location and
				// voyage
				case (load) legs.any(sameVoyageAnd(Leg.loadLocation))
				// Check that the there is one leg with same unload location and
				// voyage
				case (unload) legs.any(sameVoyageAnd(Leg.unloadLocation))
				// Check that the last leg's destination is from the event's
				// location
				case (claim) legs.last.unloadLocation == event.location 
				case (customs) true
			)
			else false;
	}
		
	
}
