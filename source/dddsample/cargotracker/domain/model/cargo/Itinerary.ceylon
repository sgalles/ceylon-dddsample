import dddsample.cargotracker.domain.model.handling {
    HandlingEvent,
    HandlingEventTypeRequiredVoyage {
        ...
    },
    HandlingEventTypeProhibitedVoyage {
        ...
    }
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
import dddsample.cargotracker.infrastructure.ceylon {
    copyDate
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

    "legs should never be empty, expect when JPA creates an empty collection
     for what should be a Null Itinerary. With method is used to detect this case
     in Cargo"
    shared Boolean hasLegs =>  _legs.sequence() nonempty;    

    shared Location initialDepartureLocation()
            => legs.first.loadLocation;
    
    shared Location finalArrivalLocation()
            => legs.last.unloadLocation;
    
    shared Date finalArrivalDate() 
            => copyDate(legs.last.unloadTime);

    shared Boolean isExpected(HandlingEvent event) {
        
        Boolean sameVoyageAnd(Location(Leg) locating, Voyage voyage)(Leg leg)
                => locating(leg).sameIdentityAs(event.location) 
                && leg.voyage.sameIdentityAs(voyage);
        
        switch (typeAndVoyage = event.typeAndVoyage)
        case ([HandlingEventTypeRequiredVoyage type, Voyage voyage]) {
            return switch (type)
            // Check that the there is one leg with same load location and
            // voyage
            case (load) legs.any(sameVoyageAnd(Leg.loadLocation,voyage))
            // Check that the there is one leg with same unload location and
            // voyage
            case (unload) legs.any(sameVoyageAnd(Leg.unloadLocation,voyage));
        }
        case (is HandlingEventTypeProhibitedVoyage) {
            return switch (typeAndVoyage)
            // Check that the first leg's origin is the event's location
            case(receive) legs.first.loadLocation.sameIdentityAs(event.location)
            // Check that the last leg's destination is from the event's
            // location
            case(claim) legs.last.unloadLocation.sameIdentityAs(event.location)
            case(customs) true;
        }

    }

}
