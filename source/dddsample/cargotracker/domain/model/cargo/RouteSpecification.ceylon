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
shared class RouteSpecification(origin, destination, Date arrivalDeadlineValue) extends AbstractSpecification<Itinerary>(){
	
	manyToOne
	joinColumn{name = "spec_origin_id"; updatable = false;}
	shared Location origin;
	
	manyToOne
	joinColumn{name = "spec_destination_id";}
	shared Location destination;
	
	temporal(TemporalType.date)
	column{name = "spec_arrival_deadline";}
	Date _arrivalDeadline = if(is Date adl = arrivalDeadlineValue.clone()) then adl else nothing;
	
	shared Date arrivalDeadline => Date(_arrivalDeadline.time);
	
	shared actual Boolean isSatisfiedBy(Itinerary itinerary) 
			=> origin.sameIdentityAs(itinerary.initialDepartureLocation())
                && destination.sameIdentityAs(itinerary.finalArrivalLocation())
                && arrivalDeadline.after(itinerary.finalArrivalDate());
	
	
	
}