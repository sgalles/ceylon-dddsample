
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
	convert=convert__FIELD,
	entity,
	id=id__FIELD,
	generatedValue=generatedValue__FIELD,
	column=column__FIELD,
	manyToOne=manyToOne__FIELD,
	joinColumn=joinColumn__FIELD,
	temporal=temporal__FIELD,
	TemporalType,
	namedQuery
}
import dddsample.cargotracker.infrastructure.persistence.jpa {

	HandlingEventTypeConverter
}


 

shared abstract class HandlingEventType() of HandlingEventTypeRequiredVoyage | HandlingEventTypeProhibitedVoyage{
	shared formal Boolean requiresVoyage;
	shared Boolean prohibitsVoyage => !requiresVoyage;
}

shared abstract class HandlingEventTypeRequiredVoyage() 
		of load | unload extends HandlingEventType() {
	shared actual Boolean requiresVoyage => true;
}

shared abstract class HandlingEventTypeProhibitedVoyage() 
		of receive | claim |  customs extends HandlingEventType() {
	shared actual Boolean requiresVoyage => false;
} 

shared object load extends HandlingEventTypeRequiredVoyage() {}
shared object unload extends HandlingEventTypeRequiredVoyage() {}
shared object receive extends HandlingEventTypeProhibitedVoyage() {}
shared object claim extends HandlingEventTypeProhibitedVoyage() {}
shared object customs extends HandlingEventTypeProhibitedVoyage() {}

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
	
	temporal(TemporalType.\iDATE)
	column{name="completion";}
	Date _completionTime;
	
	temporal(TemporalType.\iDATE)
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
		case(is [HandlingEventTypeRequiredVoyage, Voyage]){
			this.type = typeAndVoyage[0];
			this.voyage = typeAndVoyage[1];
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