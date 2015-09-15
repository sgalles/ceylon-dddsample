import dddsample.cargotracker.domain.model.location {
	Location
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
	CargoRoute,
	RouteCandidate
}

import java.util {
	Date
}


"""This facade shields the domain layer - model, services, repositories - from
   concerns about such things as the user interface and remoting.
   """
shared interface BookingServiceFacade {
	shared formal String bookNewCargo(variable String origin, variable String destination, variable Date arrivalDeadline);
	shared formal CargoRoute loadCargoForRouting(variable String trackingId);
	shared formal void assignCargoToRoute(variable String trackingId, variable RouteCandidate route);
	shared formal void changeDestination(variable String trackingId, variable String destinationUnLocode);
	shared formal List<RouteCandidate> requestPossibleRoutesForCargo(variable String trackingId);
	shared formal List<Location> listShippingLocations();
	shared formal List<CargoRoute> listAllCargos();
}