import dddsample.cargotracker.application {
    BookingService
}
import dddsample.cargotracker.domain.model.cargo {
    Itinerary,
    TrackingId,
    CargoRepository,
    RouteSpecification,
    Cargo
}
import dddsample.cargotracker.domain.model.location {
    UnLocode,
    LocationRepository
}
import dddsample.cargotracker.domain.service {
    RoutingService
}

import java.util {
    Date
}

import javax.ejb {
    stateless
}
import javax.inject {
    inject
}

import org.slf4j {
    Logger
}

stateless
inject 
shared class DefaultBookingService(
    LocationRepository locationRepository,
    CargoRepository cargoRepository,
    RoutingService routingService
) satisfies BookingService {

    inject
    late Logger logger;

    shared actual TrackingId bookNewCargo(UnLocode originUnLocode, UnLocode destinationUnLocode, Date arrivalDeadline) {
        assert (exists origin = locationRepository.find(originUnLocode),
                exists destination = locationRepository.find(destinationUnLocode));

        value cargo = Cargo {
            trackingId = cargoRepository.nextTrackingId();
            routeSpecification = RouteSpecification {
                origin = origin;
                destination = destination;
                arrivalDeadlineValue = arrivalDeadline;
            };
        };

        cargoRepository.store(cargo);
        logger.info("Booked new cargo with tracking id {0}", cargo.trackingId.idString);

        return cargo.trackingId;
    }

    shared actual List<Itinerary> requestPossibleRoutesForCargo(TrackingId trackingId)
        => if (exists cargo = cargoRepository.find(trackingId))
        then routingService.fetchRoutesForSpecification(cargo.routeSpecification)
        else [];

    shared actual void assignCargoToRoute(Itinerary itinerary, TrackingId trackingId) {
        assert (exists cargo = cargoRepository.find(trackingId));
        cargoRepository.store(cargo,itinerary);
        logger.info("Assigned cargo {0} to new route", trackingId);
    }

    shared actual void changeDestination(TrackingId trackingId, UnLocode unLocode) {
        assert (exists cargo  = cargoRepository.find(trackingId),
                exists newDestination = locationRepository.find(unLocode));

        value routeSpecification = RouteSpecification {
            origin = cargo.origin;
            destination = newDestination;
            arrivalDeadlineValue = cargo.routeSpecification.arrivalDeadline;
        };
        cargo.specifyNewRoute(routeSpecification);

        cargoRepository.store(cargo);

        logger.info("Changed destination for cargo {0} to {1}",
                trackingId, routeSpecification.destination);
    }


}