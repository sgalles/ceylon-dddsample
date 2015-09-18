import dddsample.cargotracker.application {
	BookingService
}
import dddsample.cargotracker.domain.model.cargo {
	CargoRepository
}
import dddsample.cargotracker.domain.model.location {
	LocationRepository
}
import dddsample.cargotracker.domain.model.voyage {
	VoyageRepository
}
import dddsample.cargotracker.interfaces.booking.facade {
	BookingServiceFacade
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
	RouteCandidate,
	CargoRoute,
	Location
}

import java.io {
	Serializable
}
import java.util {
	Date
}

import javax.enterprise.context {
	applicationScoped
}
import javax.inject {
	inject=inject__SETTER
}

applicationScoped
shared class DefaultBookingServiceFacade() satisfies BookingServiceFacade&Serializable{
	
	//inject
	//late BookingService bookingService;
	
	inject
	late LocationRepository locationRepository;
	
	inject
	late CargoRepository cargoRepository;
	
	inject
	late VoyageRepository voyageRepository;
	
	shared actual List<Location> listShippingLocations() => nothing;
	
	shared actual void assignCargoToRoute(String trackingId, RouteCandidate route) {}
	
	shared actual String bookNewCargo(String origin, String destination, Date arrivalDeadline) => nothing;
	
	shared actual void changeDestination(String trackingId, String destinationUnLocode) {}
	
	shared actual List<CargoRoute> listAllCargos() => nothing;
	
	shared actual CargoRoute loadCargoForRouting(String trackingId) => nothing;
	
	shared actual List<RouteCandidate> requestPossibleRoutesForCargo(String trackingId) => nothing;
	
	
}