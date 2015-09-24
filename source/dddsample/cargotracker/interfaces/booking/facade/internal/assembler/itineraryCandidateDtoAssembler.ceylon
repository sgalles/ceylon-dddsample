import dddsample.cargotracker.application.util {
	toDate
}
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
				ModelItinerary.init{
				legs = routeCandidateDTO.legs.map((legDTO) =>
					ModelLeg.init{ 
						voyage = voyageRepository.find(VoyageNumber.init(legDTO.voyageNumber)) else nothing;
						loadLocation = locationRepository.find(UnLocode.withCountryAndLocation(legDTO.fromUnLocode)) else nothing;
						unloadLocation = locationRepository.find(UnLocode.withCountryAndLocation(legDTO.toUnLocode)) else nothing;
						loadTime = dateFormat.parse(legDTO.loadTime);
						unloadTime = dateFormat.parse(legDTO.unloadTime);
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