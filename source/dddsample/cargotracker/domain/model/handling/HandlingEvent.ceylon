import dddsample.cargotracker.domain.infrastructure.persistence.jpa {
	HandlingEventTypeConverter
}

import java.lang {
	Long
}

import javax.persistence {
	convert=convert__FIELD,
	entity,
	namedQuery,
	id = id__FIELD,
	generatedValue = generatedValue__FIELD,
	column = column__FIELD
}


shared abstract class HandlingEventType(shared Boolean voyageRequired) 
		of load | unload | receive | claim | customs{
}

shared object load extends HandlingEventType(true) {}
shared object unload extends HandlingEventType(true) {}
shared object receive extends HandlingEventType(false) {}
shared object claim extends HandlingEventType(false) {}
shared object customs extends HandlingEventType(false) {}



// TODO : complete
entity
/*namedQuery{name = "HandlingEvent.findByTrackingId";
	query = "Select e from HandlingEvent e where e.cargo.trackingId = :trackingId";}*/
shared class HandlingEvent() {
	
	// Auto-generated surrogate key
	id
	generatedValue
	Long? id = null;
	
	convert{converter = `HandlingEventTypeConverter`;}
	column{name="type";}
	shared HandlingEventType type = load;
}