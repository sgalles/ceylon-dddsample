import dddsample.cargotracker.domain.model.cargo {
    ModelItinerary=Itinerary,
    ModelLeg=Leg
}
import dddsample.cargotracker.domain.model.location {
    LocationRepository,
    UnLocode
}
import dddsample.cargotracker.domain.model.voyage {
    VoyageRepository,
    VoyageNumber
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
    RouteCandidate,
    Leg
}

import java.text {
    SimpleDateFormat
}

shared object itineraryCandidateDtoAssembler {

	value dateFormat = SimpleDateFormat("MM/dd/yyyy hh:mm a z");

	shared RouteCandidate toDTO(ModelItinerary itinerary)
			=> RouteCandidate(itinerary.legs.map((leg) => Leg {
				voyageNumber = leg.voyage.voyageNumber.number;
				fromUnLocode = leg.loadLocation.unLocode.idString;
				fromName = leg.loadLocation.name;
				toUnLocode = leg.unloadLocation.unLocode.idString;
				toName = leg.unloadLocation.name;
				loadTimeDate = leg.loadTime;
				unloadTimeDate = leg.unloadTime;
			}));
	
	shared ModelItinerary fromDTO(RouteCandidate routeCandidateDTO, VoyageRepository voyageRepository, LocationRepository locationRepository)
			=> ModelItinerary(routeCandidateDTO.legsSequence.map((legDTO) {
				assert (exists voyage = voyageRepository.find(VoyageNumber(legDTO.voyageNumber)),
						exists loadLoc = locationRepository.find(UnLocode(legDTO.fromUnLocode)),
						exists unloadLoc = locationRepository.find(UnLocode(legDTO.toUnLocode)));
				return ModelLeg {
					voyage = voyage;
					loadLocation = loadLoc;
					unloadLocation = unloadLoc;
					loadTimeValue = dateFormat.parse(legDTO.loadTime);
					unloadTimeValue = dateFormat.parse(legDTO.unloadTime);
				};
			}));

}