import ceylon.language.meta {
	type
}

import dddsample.cargotracker.domain.model.cargo {
	CargoModel=Cargo,
	misrouted,
	claimed
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
	CargoRoute,
	Leg
}

shared object cargoRouteDtoAssembler{
	shared CargoRoute toDto(CargoModel cargo) 
			=> CargoRoute {
				trackingId = cargo.trackingId.idString;
				origin =  "``cargo.origin.name`` (``cargo.origin.unLocode.idString``)";
				finalDestination = let(destination = cargo.routeSpecification.destination) "``destination.name`` (``destination.unLocode.idString``)";
				arrivalDeadlineDate = cargo.routeSpecification.arrivalDeadline;
				misrouted = cargo.delivery.routingStatus == misrouted;
				claimed = cargo.delivery.transportStatus == claimed;
				lastKnownLocation = let(lastKnownLocation = cargo.delivery.lastKnownLocation) "``lastKnownLocation.name`` (``lastKnownLocation.unLocode.idString``)";
				transportStatus = type(cargo.delivery.transportStatus).declaration.name;
				legs = (cargo.itinerary else nothing).legsMaybeEmpty.map((leg) => Leg { 
							voyageNumber = leg.voyage.voyageNumber.number; 
							fromUnLocode = leg.loadLocation.unLocode.idString; 
							fromName = leg.loadLocation.name; 
							toUnLocode = leg.unloadLocation.unLocode.idString; 
							toName = leg.unloadLocation.name; 
							loadTimeDate = leg.loadTime; 
							unloadTimeDate = leg.unloadTime;
						});
			};
	
		 
}