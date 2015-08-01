import dddsample.cargotracker.domain.model.location {
	Location
}

import java.io {
	Serializable
}
import java.lang {
	Long
}

import javax.persistence {
	entity,
	embedded__FIELD,
	id__FIELD,
	generatedValue__FIELD,
	namedQueries,
	namedQuery,
	manyToOne__FIELD,
	joinColumn__FIELD
}

entity
namedQueries({
	namedQuery{name = "Cargo.findAll";
		query = "Select c from Cargo c";},
		namedQuery{name = "Cargo.findByTrackingId";
			query = "Select c from Cargo c where c.trackingId = :trackingId";}	
}) 
shared class Cargo satisfies Serializable{
	
	// Auto-generated surrogate key
	id__FIELD
	generatedValue__FIELD
	Long? id = null;
	
	embedded__FIELD 
	shared TrackingId trackingId;
	
	manyToOne__FIELD
	joinColumn__FIELD{name = "origin_id";  updatable = false; }
	shared Location origin;
	
	embedded__FIELD
	shared RouteSpecification routeSpecification;
	
	shared new init(TrackingId trackingId, RouteSpecification routeSpecification){
		this.trackingId = trackingId;
		this.routeSpecification = routeSpecification;
		// Cargo origin never changes, even if the route specification changes.
		// However, at creation, cargo orgin can be derived from the initial
		// route specification.
		this.origin = routeSpecification.origin;
	}
	
	shared new() extends init(TrackingId(""), RouteSpecification()){
		
	}
	
}