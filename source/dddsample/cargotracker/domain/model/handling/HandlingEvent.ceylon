import dddsample.cargotracker.domain.model.cargo {
    Cargo
}
import dddsample.cargotracker.domain.model.location {
    Location
}
import dddsample.cargotracker.domain.model.voyage {
    Voyage
}
import dddsample.cargotracker.infrastructure.persistence.jpa {
    HandlingEventTypeConverter
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

shared abstract class HandlingEventType() 
         of HandlingEventTypeRequiredVoyage 
          | HandlingEventTypeProhibitedVoyage {

	shared formal Boolean requiresVoyage;
	shared Boolean prohibitsVoyage => !requiresVoyage;

}

shared class HandlingEventTypeRequiredVoyage
		of load | unload extends HandlingEventType {

	requiresVoyage => true;
	shared actual String string;

	shared new load extends HandlingEventType() {string="load";}
	shared new unload extends HandlingEventType() {string="unload";}
}

shared class HandlingEventTypeProhibitedVoyage
		of receive | claim |  customs 
        extends HandlingEventType {

	requiresVoyage => false;
	shared actual String string;

	shared new receive extends HandlingEventType() {string="receive";}
	shared new claim extends HandlingEventType() {string="claim";}
	shared new customs extends HandlingEventType() {string="customs";}
} 

shared alias HandlingEventTypeBundle<Info>
		=> HandlingEventTypeProhibitedVoyage
		 | [HandlingEventTypeRequiredVoyage, Info];
 
entity
namedQuery{
	name = "HandlingEvent.findByTrackingId";
	query = "Select e from HandlingEvent e where e.cargo.trackingId = :trackingId";
}
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

	Date copy(Date date) => Date(date.time);

	shared new (
		Cargo cargo,
		Date completionTime,
		Date registrationTime,
		Location location,
		HandlingEventTypeBundle<Voyage> typeAndVoyage
	){
		switch (typeAndVoyage)
		case (is HandlingEventTypeProhibitedVoyage) {
			this.type = typeAndVoyage;
			this.voyage = null;
		}
		case ([HandlingEventTypeRequiredVoyage type, Voyage voyage]) {
			this.type = type;
			this.voyage = voyage;
		}

		this._completionTime = copy(completionTime);
		this._registrationTime = copy(registrationTime);
		this.location = location;
		this.cargo = cargo;
	}
	
	shared Date completionTime => copy(_completionTime);
	
	shared Date registrationTime => copy(_registrationTime);
	
	shared HandlingEventTypeBundle<Voyage> typeAndVoyage {
		switch(type)
		case (is HandlingEventTypeProhibitedVoyage) {
			return type;
		}
		case (is HandlingEventTypeRequiredVoyage) {
			assert(exists voyage = voyage);
			return [type,voyage];
		}
	}

}
