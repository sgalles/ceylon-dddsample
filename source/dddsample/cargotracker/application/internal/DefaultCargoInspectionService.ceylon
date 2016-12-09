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
    HandlingEventRepository
}
import dddsample.cargotracker.infrastructure.events.cdi {
    cargoInspected
}

import javax.ejb {
    stateless
}
import javax.enterprise.event {
    Event
}
import javax.inject {
    inject
}

import org.slf4j {
    Logger
}

stateless
inject
shared class DefaultCargoInspectionService ( 
        ApplicationEvents applicationEvents,
        CargoRepository cargoRepository,
        HandlingEventRepository handlingEventRepository,
        Logger logger,
        cargoInspected Event<Cargo> cargoInspected
    ) satisfies CargoInspectionService{


    shared actual void inspectCargo(TrackingId trackingId) {
        logger.info("Inspecting cargo ``trackingId.idString``");

        if (exists cargo = cargoRepository.find(trackingId)) {
            logger.info("Found cargo ``trackingId.idString``");

            value handlingHistory = handlingEventRepository
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

        }
        else {
            logger.warn("Can't inspect non-existing cargo ``trackingId``");
        }

    }

}