
import dddsample.cargotracker.interfaces.booking.facade.dto {
    CargoRoute,
    RouteCandidate,
    Location
}

import java.util {
    Date
}


"""This facade shields the domain layer - model, services, repositories - from
   concerns about such things as the user interface and remoting.
   """
shared interface BookingServiceFacade {
	shared formal String bookNewCargo(String origin, String destination, Date arrivalDeadline);
	shared formal CargoRoute loadCargoForRouting(String trackingId);
	shared formal void assignCargoToRoute(String trackingId, RouteCandidate route);
	shared formal void changeDestination(String trackingId, String destinationUnLocode);
	shared formal List<RouteCandidate> requestPossibleRoutesForCargo(String trackingId);
	shared formal List<Location> listShippingLocations();
	shared formal List<CargoRoute> listAllCargos();
}