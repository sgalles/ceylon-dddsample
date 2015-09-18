import dddsample.cargotracker.domain.model.cargo {
	TrackingId,
	Itinerary
}
import dddsample.cargotracker.domain.model.location {
	UnLocode
}

import java.util {
	Date
}


/**
 * Cargo booking service.
 */
shared interface BookingService {
	
	
	"Registers a new cargo in the tracking system, not yet routed."
	shared formal TrackingId bookNewCargo(UnLocode origin, UnLocode destination, Date arrivalDeadline);
	
	/**
	 * Requests a list of itineraries describing possible routes for this cargo.
	 *
	 * @param trackingId cargo tracking id
	 * @return A list of possible itineraries for this cargo
	 */
	shared formal List<Itinerary> requestPossibleRoutesForCargo(TrackingId trackingId);
	
	shared formal void assignCargoToRoute(Itinerary itinerary, TrackingId trackingId);
	
	shared formal void changeDestination(TrackingId trackingId, UnLocode unLocode);
}
