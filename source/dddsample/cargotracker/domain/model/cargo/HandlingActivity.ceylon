


import dddsample.cargotracker.domain.infrastructure.persistence.jpa {
	HandlingEventTypeConverter
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEventType,
	HandlingEventTypeBundle,
	HandlingEventTypeProhibitedVoyage,
	HandlingEventTypeRequiredVoyage,
	receive
}
import dddsample.cargotracker.domain.model.location {
	Location
}
import dddsample.cargotracker.domain.model.voyage {
	Voyage
}

import javax.persistence {
	embeddable,
	convert=convert__FIELD,
	column=column__FIELD,
	manyToOne=manyToOne__FIELD,
	joinColumn=joinColumn__FIELD
}

 
embeddable
shared class HandlingActivity {
	
	convert{converter = `HandlingEventTypeConverter`;}
	column{name="type";}
	shared HandlingEventType type;
	
	manyToOne
	joinColumn{name = "next_expected_location_id";}
	shared Location location;
	
	manyToOne
	joinColumn{name = "next_expected_voyage_id";}
	shared Voyage? voyage;
	
	
	
	shared new init(HandlingEventTypeProhibitedVoyage|[HandlingEventTypeRequiredVoyage, Voyage] typeAndVoyage, Location location){
		this.location = location;
		switch(typeAndVoyage) 
		case(is HandlingEventTypeProhibitedVoyage){
			this.type = typeAndVoyage; 
			this.voyage = null; 
		}
		case(is [HandlingEventTypeRequiredVoyage, Voyage]){
			this.type = typeAndVoyage[0];
			this.voyage = typeAndVoyage[1];
		}
	} 
	 
	shared new () extends init(receive, Location.unknown){}
	
	
	 

	
}
