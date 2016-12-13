import dddsample.cargotracker.domain.model.cargo {
    Itinerary,
    Leg
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
    LegDto=Leg
}

import java.text {
    SimpleDateFormat
}

shared object itineraryCandidateDtoAssembler {

    value dateFormat = SimpleDateFormat("MM/dd/yyyy hh:mm a z");

    shared RouteCandidate toDTO(Itinerary itinerary)
            => RouteCandidate(itinerary.legs.map((currentLeg) => LegDto {
                voyageNumber = currentLeg.voyage.voyageNumber.number;
                fromUnLocode = currentLeg.loadLocation.unLocode.idString;
                fromName = currentLeg.loadLocation.name;
                toUnLocode = currentLeg.unloadLocation.unLocode.idString;
                toName = currentLeg.unloadLocation.name;
                loadTimeDate = currentLeg.loadTime;
                unloadTimeDate = currentLeg.unloadTime;
            }));

    shared Itinerary fromDTO(RouteCandidate routeCandidateDTO, VoyageRepository voyageRepository, LocationRepository locationRepository)
            => Itinerary(routeCandidateDTO.legsSequence.map((currentLegDto) {
                assert (exists voyage = voyageRepository.find(VoyageNumber(currentLegDto.voyageNumber)),
                        exists loadLoc = locationRepository.find(UnLocode(currentLegDto.fromUnLocode)),
                        exists unloadLoc = locationRepository.find(UnLocode(currentLegDto.toUnLocode)));
                return Leg {
                    voyage = voyage;
                    loadLocation = loadLoc;
                    unloadLocation = unloadLoc;
                    loadTimeValue = dateFormat.parse(currentLegDto.loadTime);
                    unloadTimeValue = dateFormat.parse(currentLegDto.unloadTime);
                };
            }));

}