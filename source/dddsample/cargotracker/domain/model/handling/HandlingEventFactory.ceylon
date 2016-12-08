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

    Entity findEntity<Entity,Id>(Entity?(Id) find, Exception(Id) createError)(Id id) {
        if (exists entity = find(id)) {
            return entity;
        }
        else {
            throw createError(id);
        }
    }

    Cargo(TrackingId) findCargo = findEntity(cargoRepository.find, UnknownCargoException);
    Voyage(VoyageNumber) findVoyage = findEntity(voyageRepository.find, UnknownVoyageException);
    Location(UnLocode) findLocation = findEntity(locationRepository.find, UnknownLocationException);

    shared HandlingEvent createHandlingEvent(Date registrationTime,
		Date completionTime, TrackingId trackingId,
		UnLocode unlocode,
		HandlingEventTypeBundle<VoyageNumber> typeAndVoyageNumber)
			=> HandlingEvent {
				cargo = findCargo(trackingId);
				completionTime = completionTime;
				registrationTime = registrationTime;
				location = findLocation(unlocode);
				typeAndVoyage
						= switch (typeAndVoyageNumber)
						case (is HandlingEventTypeProhibitedVoyage)
							typeAndVoyageNumber
						case([HandlingEventTypeRequiredVoyage type, VoyageNumber voyageNumber])
							[type, findVoyage(voyageNumber)];
			};

}