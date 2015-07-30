import dddsample.cargotracker.domain.model.location {
	Location,
	UnLocode
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
shared class Cargo(trackingId) satisfies Serializable{
	
	// Auto-generated surrogate key
	id__FIELD
	generatedValue__FIELD
	Integer? id = null;
	
	embedded__FIELD 
	shared TrackingId trackingId;
	
	/*manyToOne__FIELD
	joinColumn__FIELD{name = "origin_id";  updatable = false; }
	shared Location origin = Location(UnLocode("mycontrylocation"), "myUnLocode");*/
	
}