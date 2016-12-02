import dddsample.cargotracker.domain.model.cargo {
	CargoRepository,
	Cargo,
	TrackingId
}
import dddsample.cargotracker.domain.model.location {
	LocationRepository,
	Location,
	UnLocode
}
import dddsample.cargotracker.domain.model.voyage {
	VoyageRepository,
	VoyageNumber,
	Voyage
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
shared class HandlingEventFactory(
	CargoRepository cargoRepository,
	VoyageRepository voyageRepository,
	LocationRepository locationRepository
) {
	 
	shared HandlingEvent createHandlingEvent(Date registrationTime,
		Date completionTime, TrackingId trackingId,
		UnLocode unlocode,
		HandlingEventTypeBundle<VoyageNumber> typeAndVoyageNumber) {
		
		Cargo cargo = findCargo(trackingId);
		Location location = findLocation(unlocode);
		HandlingEventTypeBundle<Voyage>  typeAndVoyage 
				=  switch(typeAndVoyageNumber)
					case(is HandlingEventTypeProhibitedVoyage) 
						let(type = typeAndVoyageNumber)
						type
					case(is [HandlingEventTypeRequiredVoyage, VoyageNumber]) 
						let([type,voyageNumber] = typeAndVoyageNumber)
						let(voyage = findVoyage(voyageNumber))
						[type, voyage];
		
		return HandlingEvent(cargo, completionTime,
					registrationTime, location, typeAndVoyage);  
	}
	

    Cargo(TrackingId) findCargo => findEntity(cargoRepository.find, UnknownCargoException);
    Voyage(VoyageNumber) findVoyage => findEntity(voyageRepository.find, UnknownVoyageException);
    Location(UnLocode) findLocation => findEntity(locationRepository.find, UnknownLocationException);
    
    Entity findEntity<Entity,Id>(Entity?(Id) find, Exception(Id) createError)(Id id){
        if(exists entity = find(id)){
            return entity;
        }else{
            throw createError(id);
        }
    }
	
}