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

"Registers a handling event in the system, and notifies interested parties
 that a cargo has been handled."
shared interface HandlingEventService {
	shared formal void registerHandlingEvent(Date completionTime, TrackingId trackingId, HandlingEventTypeBundle<VoyageNumber> eventTypeBundle, UnLocode unLocode);
}
