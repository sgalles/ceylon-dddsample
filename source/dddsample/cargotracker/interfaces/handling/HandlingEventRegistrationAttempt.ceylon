import dddsample.cargotracker.domain.model.cargo {
	TrackingId
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEventTypeBundle
}
import dddsample.cargotracker.domain.model.location {
	UnLocode
}
import dddsample.cargotracker.domain.model.voyage {
	VoyageNumber
}

import java.util {
	Date
}

"""
   This is a simple transfer object for passing incoming handling event
   registration attempts to the proper registration procedure.
 
   It is used as a message queue element.
   """
shared class HandlingEventRegistrationAttempt(
	shared Date registrationTime,
	shared Date completionTime,
	shared TrackingId trackingId,
	shared HandlingEventTypeBundle<VoyageNumber> typeAndVoyage,
	shared UnLocode unLocode
) {
	string => "registrationTime=``registrationTime``
	           completionTime=``completionTime``
	           trackingId=``trackingId``
	           typeAndVoyage=``typeAndVoyage``
	           unLocode=``unLocode``"
			.replace("\n","");
}