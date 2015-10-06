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
	embedded=embedded__FIELD,
	id=id__FIELD,
	generatedValue=generatedValue__FIELD,
	namedQueries,
	namedQuery,
	manyToOne=manyToOne__FIELD,
	joinColumn=joinColumn__FIELD
}

entity
namedQueries({
	namedQuery{name = "Cargo.findAll";
		query = "Select c from Cargo c";},
		namedQuery{name = "Cargo.findByTrackingId";
			query = "Select c from Cargo c where c.trackingId = :trackingId";}	
}) 
shared class Cargo{
	
	// Auto-generated surrogate key
	id
	generatedValue
	Long? id = null;
	
	embedded 
	shared TrackingId trackingId;
	
	manyToOne
	joinColumn{name = "origin_id";  updatable = false; }
	shared Location origin;
	
	embedded
	shared variable RouteSpecification routeSpecification;
	
	embedded
	variable Itinerary? _itinerary = null;
	
	embedded
	variable Delivery _delivery;
	
	shared new init(TrackingId trackingId, RouteSpecification routeSpecification){
		this.trackingId = trackingId;
		// Cargo origin never changes, even if the route specification changes.
		// However, at creation, cargo orgin can be derived from the initial
		// route specification.
		this.origin = routeSpecification.origin;
		this.routeSpecification = routeSpecification;
		
		this._delivery = Delivery.derivedFrom(routeSpecification,
                this._itinerary, HandlingHistory.empty); // TODO : WAT ? this._itinerary is always here null. Strange.
	}
	
	shared new() extends init(TrackingId(), RouteSpecification()){}
	
	shared Itinerary? itinerary => _itinerary;
	
	shared Delivery delivery => _delivery;
	
	shared void assignToRoute(Itinerary itinerary){
		this._itinerary = itinerary;
		this._delivery = delivery.updateOnRouting(routeSpecification, itinerary);
	}
	
	shared void specifyNewRoute(RouteSpecification routeSpecification) {
		this.routeSpecification = routeSpecification;
		// Handling consistency within the Cargo aggregate synchronously
		// TODO try to use state design pattern to remove this assert
		// actually this is because assignToRoute must be called before AFAICT
		assert(exists itinerary = this.itinerary); 
		this._delivery = delivery.updateOnRouting(this.routeSpecification, itinerary);
	}
	
	shared void deriveDeliveryProgress(HandlingHistory handlingHistory) {
		this._delivery = Delivery.derivedFrom(routeSpecification, itinerary,handlingHistory);
	}
	
	
}