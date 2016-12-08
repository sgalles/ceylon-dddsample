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
	entity,
	id,
	generatedValue,
	manyToOne,
	joinColumn,
	temporal,
	TemporalType,
	column
}


entity
shared class Leg(voyage, loadLocation, unloadLocation, Date loadTimeValue, Date unloadTimeValue) {
	
	suppressWarnings("unusedDeclaration")
	id
	generatedValue
	Long? id = null;
	
	manyToOne
	joinColumn{name = "voyage_id";}
	shared Voyage voyage;
		
	manyToOne
	joinColumn{name = "load_location_id";}
	shared Location loadLocation;	
		
	manyToOne
	joinColumn{name = "unload_location_id";}
	shared Location unloadLocation;
		
	temporal(TemporalType.timestamp)
	column{name = "load_time";}
	Date _loadTime = loadTimeValue;
	
	temporal(TemporalType.timestamp)
	column{name = "unload_time";}
	Date _unloadTime = unloadTimeValue;
	
	
	shared Date loadTime => Date(_loadTime.time);
	
	shared Date unloadTime => Date(_unloadTime.time);
	
	
}