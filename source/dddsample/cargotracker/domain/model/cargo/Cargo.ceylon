import dddsample.cargotracker.domain.model.handling {
    HandlingHistory
}
import dddsample.cargotracker.domain.model.location {
    Location
}

import java.lang {
    Long
}

import javax.persistence {
    entity,
    embedded,
    id,
    generatedValue,
    namedQueries,
    namedQuery,
    manyToOne,
    joinColumn
}

entity
namedQueries {
    namedQuery {
        name = "Cargo.findAll";
        query = "Select c from Cargo c";
    },
    namedQuery {
        name = "Cargo.findByTrackingId";
        query = "Select c from Cargo c where c.trackingId = :trackingId";
    }
}
shared class Cargo(trackingId, routeSpecification){

    // Auto-generated surrogate key
    suppressWarnings("unusedDeclaration")
    id
    generatedValue
    Long? id = null;

    embedded
    shared TrackingId trackingId;

    embedded
    shared variable RouteSpecification routeSpecification;

    // Cargo origin never changes, even if the route specification changes.
    // However, at creation, cargo orgin can be derived from the initial
    // route specification.
    manyToOne
    joinColumn{name = "origin_id";  updatable = false; }
    shared Location origin = routeSpecification.origin;

    embedded
    variable Itinerary? _itinerary = null;

    // when hasLegs is false, it means that JPA has created an empty collection instead of a null itinerary.
    // let's fix this here
    shared Itinerary? itinerary =>  if(exists currentItinerary = _itinerary, currentItinerary.hasLegs) 
                                    then currentItinerary
                                    else null;

    embedded
    variable Delivery _delivery = Delivery.derivedFrom {
        routeSpecification = routeSpecification;
        itinerary = this.itinerary;
        handlingHistory = HandlingHistory.empty;
    }; 


    shared Delivery delivery => _delivery;

    shared void assignToRoute(Itinerary itinerary) {
        this._itinerary = itinerary;
        this._delivery = delivery.updateOnRouting(routeSpecification, itinerary);
    }

    shared void specifyNewRoute(RouteSpecification routeSpecification) {
        this.routeSpecification = routeSpecification;
        // Handling consistency within the Cargo aggregate synchronously
        this._delivery = delivery.updateOnRouting(this.routeSpecification, itinerary);
    }

    shared void deriveDeliveryProgress(HandlingHistory handlingHistory) {
        this._delivery = Delivery.derivedFrom {
            routeSpecification = routeSpecification;
            itinerary = itinerary;
            handlingHistory = handlingHistory;
        };
    }


}