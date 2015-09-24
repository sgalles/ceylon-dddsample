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
	misrouted, claimed,  lastKnownLocation, transportStatus, legs) satisfies Serializable{
	
	value dateFormat = SimpleDateFormat("MM/dd/yyyy hh:mm a z");
	
	shared String trackingId;
	shared String origin;
	shared String finalDestination;
	shared String arrivalDeadline = dateFormat.format(arrivalDeadlineDate);
	shared Boolean misrouted;
	shared Boolean claimed;
	shared String lastKnownLocation;
	shared String transportStatus;
	shared {Leg*} legs;
	
	shared Boolean routed => !legs.empty;
}
