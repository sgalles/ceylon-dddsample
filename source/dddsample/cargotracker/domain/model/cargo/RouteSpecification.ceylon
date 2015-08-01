import dddsample.cargotracker.domain.model.location {
	Location
}
import dddsample.cargotracker.domain.shared {
	AbstractSpecification
}

import java.util {
	Date
}

import javax.persistence {
	joinColumn=joinColumn__FIELD,
	TemporalType,
	manyToOne=manyToOne__FIELD,
	temporal=temporal__FIELD,
	column=column__FIELD,
	embeddable
}

embeddable
shared class RouteSpecification extends AbstractSpecification<Itinerary>{
	
	manyToOne
	joinColumn{name = "spec_origin_id"; updatable = false;}
	shared Location origin;
	
	manyToOne
	joinColumn{name = "spec_destination_id";}
	shared Location destination;
	
	temporal(TemporalType.\iDATE)
	column{name = "spec_arrival_deadline";}
	Date _arrivalDeadline;
	
	suppressWarnings("expressionTypeNothing")
	shared new init(Location origin, Location destination, Date arrivalDeadline) extends AbstractSpecification<Itinerary>(){
		this.origin = origin;
		this.destination = destination;
		this._arrivalDeadline = if(is Date adl = arrivalDeadline.clone()) then adl else nothing;
	}
	
	shared new() extends AbstractSpecification<Itinerary>(){
		this.origin = Location.unknown;
		this.destination = Location.unknown;
		this._arrivalDeadline = Date(0);
	}
	
	
	
	shared Date arrivalDeadline => Date(_arrivalDeadline.time);
	
	shared actual Boolean isSatisfiedBy(Itinerary t) => nothing;
	
	
	
}