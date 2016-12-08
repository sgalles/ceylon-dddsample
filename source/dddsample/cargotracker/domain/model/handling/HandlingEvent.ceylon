
import dddsample.cargotracker.domain.model.cargo {
	Cargo
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
	convert,
	entity,
	id,
	generatedValue,
	column,
	manyToOne,
	joinColumn,
	temporal,
	TemporalType,
	namedQuery
}
import dddsample.cargotracker.infrastructure.persistence.jpa {
	HandlingEventTypeConverter
}


shared abstract class HandlingEventType() 
         of HandlingEventTypeRequiredVoyage 
          | HandlingEventTypeProhibitedVoyage{
	shared formal Boolean requiresVoyage;
	shared Boolean prohibitsVoyage => !requiresVoyage;
}

shared class HandlingEventTypeRequiredVoyage
		of load | unload extends HandlingEventType {
	requiresVoyage => true;
	
	shared new load extends HandlingEventType() {}
	shared new unload extends HandlingEventType() {}
}

shared class HandlingEventTypeProhibitedVoyage
		of receive | claim |  customs 
        extends HandlingEventType {
	requiresVoyage => false;

	shared new receive extends HandlingEventType() {}
	shared new claim extends HandlingEventType() {}
	shared new customs extends HandlingEventType() {}
} 

shared alias HandlingEventTypeBundle<Info> => HandlingEventTypeProhibitedVoyage|[HandlingEventTypeRequiredVoyage, Info];
 
entity
namedQuery{name = "HandlingEvent.findByTrackingId";
	query = "Select e from HandlingEvent e where e.cargo.trackingId = :trackingId";}
	
shared class HandlingEvent {
		
	suppressWarnings("unusedDeclaration")
	id
	generatedValue
	Long? id = null;
	
	convert{converter = `class HandlingEventTypeConverter`;}
	column{name="type";}
	shared HandlingEventType type;
	
	manyToOne
	joinColumn{name = "voyage_id";}
	shared Voyage? voyage;
	
	manyToOne
	joinColumn{name = "location_id";}
	shared Location location;
	
	temporal(TemporalType.date)
	column{name="completion";}
	Date _completionTime;
	
	temporal(TemporalType.date)
	column{name="registration";}
	Date _registrationTime;
	
	manyToOne
	joinColumn{name = "cargo_id";}
	shared Cargo cargo;
	
	shared new (
		Cargo cargo,
		Date completionTime,
		Date registrationTime,
		Location location,
		HandlingEventTypeBundle<Voyage> typeAndVoyage
	){
		switch(typeAndVoyage)
		case(is HandlingEventTypeProhibitedVoyage){
			this.type = typeAndVoyage;
			this.voyage = null;
		}
		case([HandlingEventTypeRequiredVoyage type, Voyage voyage]){
			this.type = type;
			this.voyage = voyage;
		}
		this._completionTime = if(is Date t = completionTime.clone()) then t else nothing;
		this._registrationTime = if(is Date t = registrationTime.clone()) then t else nothing;
		this.location = location;
		this.cargo = cargo;
	}
	
	shared Date completionTime => Date(_completionTime.time);
	
	shared Date registrationTime => Date(_registrationTime.time);
	
	shared HandlingEventTypeBundle<Voyage> typeAndVoyage{
		switch(type)
		case(is HandlingEventTypeProhibitedVoyage){
			return type;
		}
		case(is HandlingEventTypeRequiredVoyage){
			assert(exists voyage = voyage);
			return [type,voyage];
		}
	}
	
	
}