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
	LocationRepository
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
	inject
}
stateless
inject 
shared class DefaultBookingService(
	LocationRepository locationRepository,
	CargoRepository cargoRepository,
	RoutingService routingService
) satisfies BookingService{
	
	shared actual TrackingId bookNewCargo(UnLocode originUnLocode, UnLocode destinationUnLocode, Date arrivalDeadline) {
		TrackingId trackingId = cargoRepository.nextTrackingId();
		assert(	exists origin = locationRepository.find(originUnLocode),
		 		exists destination = locationRepository.find(destinationUnLocode)
		);
		RouteSpecification routeSpecification = RouteSpecification(origin,
			destination, arrivalDeadline);
		
		Cargo cargo = Cargo(trackingId, routeSpecification);
		
		cargoRepository.store(cargo);
		/*logger.log(Level.INFO, "Booked new cargo with tracking id {0}",
			cargo.getTrackingId().getIdString());*/
		
		return cargo.trackingId;
	}
	
	shared actual List<Itinerary> requestPossibleRoutesForCargo(TrackingId trackingId) 
		=> 	if(exists cargo = cargoRepository.find(trackingId)) 
				then routingService.fetchRoutesForSpecification(cargo.routeSpecification)
				else [];
	
	shared actual void assignCargoToRoute(Itinerary itinerary, TrackingId trackingId) {
		assert(exists cargo = cargoRepository.find(trackingId));
		cargoRepository.store(cargo,itinerary);
		/*logger.log(Level.INFO, "Assigned cargo {0} to new route", trackingId);*/
	}
	
	shared actual void changeDestination(TrackingId trackingId, UnLocode unLocode) {
		assert(exists cargo  = cargoRepository.find(trackingId),
		       exists newDestination = locationRepository.find(unLocode)
		);
		
		RouteSpecification routeSpecification = RouteSpecification(
			cargo.origin, newDestination,
			cargo.routeSpecification.arrivalDeadline);
			cargo.specifyNewRoute(routeSpecification);
		
		cargoRepository.store(cargo);
		
		/*logger.log(Level.INFO, "Changed destination for cargo {0} to {1}",
			new Object[]{trackingId, routeSpecification.getDestination()});*/
	}
	
	
}