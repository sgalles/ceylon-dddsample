import dddsample.cargotracker.domain.infrastructure.persistence.jpa {
	HandlingEventTypeConverter
}
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
	TemporalType
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


// TODO : complete
entity
/*namedQuery{name = "HandlingEvent.findByTrackingId";
	query = "Select e from HandlingEvent e where e.cargo.trackingId = :trackingId";}*/
shared class HandlingEvent {
	
	// Auto-generated surrogate key
	id
	generatedValue
	Long? id = null;
	
	convert{converter = `HandlingEventTypeConverter`;}
	column{name="type";}
	shared HandlingEventType type;
	
	manyToOne
	joinColumn{name = "voyage_id";}
	Voyage? _voyage;
	
	manyToOne
	joinColumn{name = "location_id";}
	Location location;
	
	temporal(TemporalType.\iDATE)
	column{name="completion";}
	Date _completionTime;
	
	temporal(TemporalType.\iDATE)
	column{name="registration";}
	Date _registrationTime;
	
	manyToOne
	joinColumn{name = "cargo_id";}
	shared Cargo cargo;
	
	shared new init(
		Cargo cargo,
		Date completionTime,
		Date registrationTime,
		Location location,
		HandlingEventTypeProhibitedVoyage|[HandlingEventTypeRequiredVoyage, Voyage] typeAndVoyage
	){
		switch(typeAndVoyage)
		case(is HandlingEventTypeProhibitedVoyage){
			this.type = typeAndVoyage;
			this._voyage = null;
		}
		case(is [HandlingEventTypeRequiredVoyage, Voyage]){
			this.type = typeAndVoyage[0];
			this._voyage = typeAndVoyage[1];
		}
		this._completionTime = if(is Date t = completionTime.clone()) then t else nothing;
		this._registrationTime = if(is Date t = registrationTime.clone()) then t else nothing;
		this.location = location;
		this.cargo = cargo;
	}
	
	shared new() extends init(Cargo(), Date(0), Date(0), Location.unknown, customs){}
	
	shared Voyage voyage => _voyage else Voyage.none;
	
	shared Date completionTime => Date(_completionTime.time);
	
	shared Date registrationTime => Date(_registrationTime.time);
}