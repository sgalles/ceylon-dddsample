import dddsample.cargotracker.application {
	CargoInspectionService,
	ApplicationEvents
}
import dddsample.cargotracker.domain.model.cargo {
	TrackingId,
	CargoRepository,
	Cargo
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEventRepository,
	HandlingHistory
}
import dddsample.cargotracker.infrastructure.events.cdi{
	cargoInspected
}
import javax.ejb {
	stateless
}
import javax.enterprise.event {
	Event
}
import javax.inject {
	inject=inject__FIELD
}

import org.slf4j {
	Logger
}
stateless
shared class DefaultCargoInspectionService() satisfies CargoInspectionService{
	
	inject
	late ApplicationEvents applicationEvents;
	inject
	late CargoRepository cargoRepository;
	inject
	late HandlingEventRepository handlingEventRepository;
	
	inject
	cargoInspected
	late Event<Cargo> cargoInspected;
	
	inject
	late Logger logger;
	
	shared actual default void inspectCargo(TrackingId trackingId) {
		logger.info("Inspecting cargo ``trackingId.idString``");
		if (exists cargo = cargoRepository.find(trackingId)) {
			logger.info("Found cargo ``trackingId.idString``");
			HandlingHistory handlingHistory = handlingEventRepository
					.lookupHandlingHistoryOfCargo(trackingId);
			
			cargo.deriveDeliveryProgress(handlingHistory);
			
			if (cargo.delivery.misdirected) {
				applicationEvents.cargoWasMisdirected(cargo);
			}
			
			if (cargo.delivery.unloadedAtDestination) {
				applicationEvents.cargoHasArrived(cargo);
			}
			
			cargoRepository.store(cargo);
			
			logger.info("Firing 'cargoInspected' event");
			cargoInspected.fire(cargo);			
			
		}else{
			logger.warn("Can't inspect non-existing cargo ``trackingId``");
		}
		
		
	}
	
}