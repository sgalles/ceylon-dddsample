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
	
	shared RouteCandidate toDTO(ModelItinerary itinerary) => RouteCandidate(itinerary.legs.map(toLegDTO));
	
	shared ModelItinerary fromDTO( RouteCandidate routeCandidateDTO, VoyageRepository voyageRepository, LocationRepository locationRepository) 
			=>  let(dateFormat = SimpleDateFormat("MM/dd/yyyy hh:mm a z"))
				ModelItinerary{
				legsInit = routeCandidateDTO.legsSequence.map((legDTO) =>
					ModelLeg{ 
						voyage = voyageRepository.find(VoyageNumber(legDTO.voyageNumber)) else nothing;
						loadLocation = locationRepository.find(UnLocode(legDTO.fromUnLocode)) else nothing;
						unloadLocation = locationRepository.find(UnLocode(legDTO.toUnLocode)) else nothing;
						loadTimeValue = dateFormat.parse(legDTO.loadTime);
						unloadTimeValue = dateFormat.parse(legDTO.unloadTime);
					}
				);
			};
		
	
	
	
	Leg toLegDTO(ModelLeg leg) 
		=> Leg { 
			voyageNumber = leg.voyage.voyageNumber.number;
			fromUnLocode = leg.loadLocation.unLocode.idString;
			fromName = leg.loadLocation.name;
			toUnLocode = leg.unloadLocation.unLocode.idString;
			toName = leg.unloadLocation.name;
			loadTimeDate = leg.loadTime;
			unloadTimeDate = leg.unloadTime;
		};
}