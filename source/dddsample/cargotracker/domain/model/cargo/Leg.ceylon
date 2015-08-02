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
	id = id__FIELD,
	generatedValue = generatedValue__FIELD,
	manyToOne = manyToOne__FIELD,
	joinColumn = joinColumn__FIELD,
	temporal = temporal__FIELD,
	TemporalType,
	column = column__FIELD
}


entity
shared class Leg {
	
	// Auto-generated surrogate key
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
		
	temporal(TemporalType.\iTIMESTAMP)
	column{name = "load_time";}
	Date _loadTime;
	
	temporal(TemporalType.\iTIMESTAMP)
	column{name = "unload_time";}
	Date _unloadTime;
	
		
	shared new init(Voyage voyage, Location loadLocation, Location unloadLocation, Date loadTime, Date unloadTime){
		this.voyage = voyage;
		this.loadLocation = loadLocation;
		this.unloadLocation = unloadLocation;
		this._loadTime = loadTime;
		this._unloadTime = unloadTime;
	}
	
	shared new() extends init(Voyage(), Location(), Location(), Date(0), Date(0)){}
	
	shared Date loadTime => Date(_loadTime.time);
	
	shared Date unloadTime => Date(_unloadTime.time);
	
	
}