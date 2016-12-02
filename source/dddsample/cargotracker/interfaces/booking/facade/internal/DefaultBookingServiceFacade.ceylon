import dddsample.cargotracker.application {
	BookingService
}
import dddsample.cargotracker.domain.model.cargo {
	CargoRepository,
	TrackingId,
	Cargo
}
import dddsample.cargotracker.domain.model.location {
	LocationRepository,
	ModelLocation=Location,
	UnLocode
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
import dddsample.cargotracker.interfaces.booking.facade.internal.assembler {
	cargoRouteDtoAssembler,
	locationDtoAssembler,
	itineraryCandidateDtoAssembler
}

import java.util {
	Date
}

import javax.enterprise.context {
	applicationScoped
}
import javax.inject {
	inject
}

applicationScoped
inject
shared class DefaultBookingServiceFacade(
	BookingService bookingService,
	LocationRepository locationRepository,
	CargoRepository cargoRepository,
	VoyageRepository voyageRepository
) satisfies BookingServiceFacade{
	
	shared actual List<Location> listShippingLocations(){
		List<ModelLocation> allLocations = locationRepository.findAll();
		return locationDtoAssembler.toDtoList(allLocations);
	}
	
	shared actual String bookNewCargo(String origin, String destination, Date arrivalDeadline) {
		TrackingId trackingId = bookingService.bookNewCargo(
			UnLocode(origin), 
			UnLocode(destination),
			arrivalDeadline);
		return trackingId.idString;
	}
	
	shared actual CargoRoute loadCargoForRouting(String trackingId) {
		Cargo? cargo = cargoRepository.find(TrackingId(trackingId));
		assert(exists cargo);
		return cargoRouteDtoAssembler.toDto(cargo);
	}
	
	shared actual void assignCargoToRoute(String trackingIdStr, RouteCandidate routeCandidateDTO) {
		value itinerary = itineraryCandidateDtoAssembler.fromDTO(routeCandidateDTO, voyageRepository, locationRepository);
		value trackingId = TrackingId(trackingIdStr);
		bookingService.assignCargoToRoute(itinerary, trackingId);
	}
	
	shared actual void changeDestination(String trackingId, String destinationUnLocode) {
		bookingService.changeDestination(TrackingId(trackingId), UnLocode(destinationUnLocode));
	}
	
	shared actual List<CargoRoute> listAllCargos() 
			=> cargoRepository.findAll().collect(cargoRouteDtoAssembler.toDto);
	
	shared actual List<RouteCandidate> requestPossibleRoutesForCargo(String trackingId) 
			=> let(itineraries = bookingService.requestPossibleRoutesForCargo(TrackingId(trackingId)))
			   itineraries.collect(itineraryCandidateDtoAssembler.toDTO);	
	
	
}