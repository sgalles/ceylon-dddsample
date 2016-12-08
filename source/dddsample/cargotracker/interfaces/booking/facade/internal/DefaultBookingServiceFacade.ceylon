import dddsample.cargotracker.application {
    BookingService
}
import dddsample.cargotracker.domain.model.cargo {
    CargoRepository,
    TrackingId
}
import dddsample.cargotracker.domain.model.location {
    LocationRepository,
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
    CargoRoute
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
) satisfies BookingServiceFacade {
	
	listShippingLocations()
			=> locationDtoAssembler.toDtoList(locationRepository.findAll());
	
	bookNewCargo(String origin, String destination, Date arrivalDeadline)
			=> bookingService.bookNewCargo {
				origin = UnLocode(origin);
				destination = UnLocode(destination);
				arrivalDeadline = arrivalDeadline;
			}
		.idString;
	
	shared actual CargoRoute loadCargoForRouting(String trackingId) {
		assert (exists cargo = cargoRepository.find(TrackingId(trackingId)));
		return cargoRouteDtoAssembler.toDto(cargo);
	}
	
	assignCargoToRoute(String trackingIdStr, RouteCandidate routeCandidateDTO)
			=> bookingService.assignCargoToRoute {
				itinerary = itineraryCandidateDtoAssembler.fromDTO {
				    routeCandidateDTO = routeCandidateDTO;
				    voyageRepository = voyageRepository;
				    locationRepository = locationRepository;
				};
				trackingId = TrackingId(trackingIdStr);
			};
	
	changeDestination(String trackingId, String destinationUnLocode)
			=> bookingService.changeDestination {
			    trackingId = TrackingId(trackingId);
			    unLocode = UnLocode(destinationUnLocode);
			};
	
	listAllCargos()
			=> cargoRepository.findAll().collect(cargoRouteDtoAssembler.toDto);
	
	requestPossibleRoutesForCargo(String trackingId)
			=> bookingService.requestPossibleRoutesForCargo(TrackingId(trackingId))
			.collect(itineraryCandidateDtoAssembler.toDTO);

}