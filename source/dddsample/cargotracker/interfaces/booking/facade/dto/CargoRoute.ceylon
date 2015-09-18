import dddsample.cargotracker.application.util {
	toJavaList
}

import java.io {
	Serializable
}
import java.text {
	SimpleDateFormat
}
import java.util {
	Date,
	JList=List,
	Collections
}

"""
   DTO for registering and routing a cargo.
   """
shared class CargoRoute(trackingId, origin, finalDestination, Date arrivalDeadlineDate, 
	misrouted, claimed,  lastKnownLocation, transportStatus) satisfies Serializable{
	
	value dateFormat = SimpleDateFormat("MM/dd/yyyy hh:mm a z");
	
	shared String trackingId;
	shared String origin;
	shared String finalDestination;
	shared String arrivalDeadline = dateFormat.format(arrivalDeadlineDate);
	shared Boolean misrouted;
	shared Boolean claimed;
	shared String lastKnownLocation;
	shared String transportStatus;
	JList<Leg> _legs = toJavaList<Leg>({});
	
	shared JList<Leg> legs => Collections.unmodifiableList(_legs);
	shared void addLeg(Leg leg){
		_legs.add(leg);
	}
	
	shared Boolean routed => !_legs.empty;
}
