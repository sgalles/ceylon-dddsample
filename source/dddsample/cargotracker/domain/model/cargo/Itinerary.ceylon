import dddsample.cargotracker.domain.model.handling {
	HandlingEvent,
	HandlingEventTypeRequiredVoyage {
		...
	},
	HandlingEventTypeProhibitedVoyage {
		...
	},
	load,
	unload,
	receive,
	claim,
	customs
}
import dddsample.cargotracker.domain.model.location {
	Location
}
import dddsample.cargotracker.domain.model.voyage {
	Voyage
}

import java.lang {
	Long
}
import java.util {
	Date
}

import javax.persistence {
	CascadeType,
	embeddable,
	joinColumn,
	oneToMany,
	FetchType,
	orderBy
}

shared Date endOfDays = Date(Long.maxValue);

embeddable
shared class Itinerary({Leg+} legsInit) {
    
    oneToMany{cascade = {CascadeType.all}; fetch=FetchType.eager; } // TODO : try to use LAZY
    joinColumn{name = "cargo_id";}
    orderBy("load_time") 
    List<Leg> _legs = [*legsInit];
    
    shared [Leg+] legs {
        assert(nonempty legs = _legs.sequence());
        return legs;
    }
    
    
    shared [Leg*] legsMaybeEmpty => // TODO remove
            _legs.sequence();
    
    
    shared Location? initialDepartureLocation() 
            => legsMaybeEmpty.first?.loadLocation;	
    
    shared Location? finalArrivalLocation() 
            => legsMaybeEmpty.last?.unloadLocation;	
    
    shared Date finalArrivalDate() 
            => Date(legs.last.unloadTime.time);
    
    
    shared Boolean isExpected(HandlingEvent event) {
        
        Boolean sameVoyageAnd(Location(Leg) locating, Voyage voyage)(Leg leg)
                => locating(leg).sameIdentityAs(event.location) 
                && leg.voyage.sameIdentityAs(voyage);
        
        return switch(typeAndVoyage = event.typeAndVoyage)
        case(is [HandlingEventTypeRequiredVoyage, Voyage]) 
            let([type,voyage] = typeAndVoyage) 
            (switch(type)
                // Check that the there is one leg with same load location and
            // voyage
            case(load) legs.any(sameVoyageAnd(Leg.loadLocation,voyage))
            // Check that the there is one leg with same unload location and
            // voyage
            case(unload) legs.any(sameVoyageAnd(Leg.unloadLocation,voyage))
        )
        case(is HandlingEventTypeProhibitedVoyage) 
            let(type = typeAndVoyage) 
            (switch(type)
                // Check that the first leg's origin is the event's location
            case(receive) legs.first.loadLocation.sameIdentityAs(event.location)  
            // Check that the last leg's destination is from the event's
            // location
            case(claim) legs.last.unloadLocation.sameIdentityAs(event.location) 
            case(customs) true
        );

    }

}
