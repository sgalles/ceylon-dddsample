import dddsample.cargotracker.application {
	BookingService
}
import dddsample.cargotracker.domain.model.cargo {
	Itinerary,
	TrackingId,
	CargoRepository,
	RouteSpecification,
	Cargo
}
import dddsample.cargotracker.domain.model.location {
	UnLocode,
	LocationRepository,
	Location
}
import dddsample.cargotracker.domain.service {
	RoutingService
}

import java.util {
	Date
}

import javax.ejb {
	stateless
}
import javax.inject {
	inject=inject__SETTER
}
stateless
shared class DefaultBookingService() satisfies BookingService{
	
	inject
	late LocationRepository locationRepository;
	
	inject
	late CargoRepository cargoRepository;
	
	inject
	late RoutingService routingService;
	
	shared actual TrackingId bookNewCargo(UnLocode originUnLocode, UnLocode destinationUnLocode, Date arrivalDeadline) {
		TrackingId trackingId = cargoRepository.nextTrackingId();
		Location? origin = locationRepository.find(originUnLocode);
		assert(exists origin);
		Location? destination = locationRepository.find(destinationUnLocode);
		assert(exists destination);
		RouteSpecification routeSpecification = RouteSpecification.init(origin,
			destination, arrivalDeadline);
		
		Cargo cargo = Cargo.init(trackingId, routeSpecification);
		
		cargoRepository.store(cargo);
		/*logger.log(Level.INFO, "Booked new cargo with tracking id {0}",
			cargo.getTrackingId().getIdString());*/
		
		return cargo.trackingId;
	}
	
	shared actual default List<Itinerary> requestPossibleRoutesForCargo(TrackingId trackingId) {
		Cargo? cargo = cargoRepository.find(trackingId);
		return 	if(exists cargo) 
				then routingService.fetchRoutesForSpecification(cargo.routeSpecification)
				else [];
	}
	
	shared actual default void assignCargoToRoute(Itinerary itinerary, TrackingId trackingId) {
		Cargo? cargo = cargoRepository.find(trackingId);
		assert(exists cargo);
		cargo.assignToRoute(itinerary);
		cargoRepository.store(cargo);
		/*logger.log(Level.INFO, "Assigned cargo {0} to new route", trackingId);*/
	}
	
	shared actual default void changeDestination(TrackingId trackingId, UnLocode unLocode) {
		Cargo? cargo = cargoRepository.find(trackingId);
		assert(exists cargo);
		Location? newDestination = locationRepository.find(unLocode);
		assert(exists newDestination);
		
		RouteSpecification routeSpecification = RouteSpecification.init(
			cargo.origin, newDestination,
			cargo.routeSpecification.arrivalDeadline);
		cargo.specifyNewRoute(routeSpecification);
		
		cargoRepository.store(cargo);
		
		/*logger.log(Level.INFO, "Changed destination for cargo {0} to {1}",
			new Object[]{trackingId, routeSpecification.getDestination()});*/
	}
	
	
}