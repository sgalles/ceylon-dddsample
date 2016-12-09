import dddsample.cargotracker.domain.model.handling {
	HandlingEventType,
	HandlingEventTypeBundle,
	HandlingEventTypeProhibitedVoyage,
	HandlingEventTypeRequiredVoyage
}
import dddsample.cargotracker.domain.model.location {
	Location
}
import dddsample.cargotracker.domain.model.voyage {
	Voyage
}

import javax.persistence {
	embeddable,
	convert,
	column,
	manyToOne,
	joinColumn
}
import dddsample.cargotracker.infrastructure.persistence.jpa {
	HandlingEventTypeConverter
}

 
embeddable
shared class HandlingActivity {
	
	convert{converter = `class HandlingEventTypeConverter`;}
	column{name="type";}
	shared HandlingEventType type;
	
	manyToOne
	joinColumn{name = "next_expected_location_id";}
	shared Location location;
	
	manyToOne
	joinColumn{name = "next_expected_voyage_id";}
	shared Voyage? voyage;
	
	shared new (HandlingEventTypeBundle<Voyage> typeAndVoyage, Location location){
		this.location = location;
		switch (typeAndVoyage)
		case (is HandlingEventTypeProhibitedVoyage) {
			this.type = typeAndVoyage; 
			this.voyage = null; 
		}
		case ([HandlingEventTypeRequiredVoyage type, Voyage voyage]) {
			this.type = type;
			this.voyage = voyage;
		}
		
	} 

}
