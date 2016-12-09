import ceylon.interop.java {
    CeylonList
}

import dddsample.cargotracker.domain.model.cargo {
    TrackingId
}
import dddsample.cargotracker.domain.model.handling {
    HandlingEventRepository,
    HandlingEvent,
    HandlingHistory
}

import javax.enterprise.context {
    applicationScoped
}
import javax.inject {
    inject
}
import javax.persistence {
    EntityManager
}

applicationScoped
inject
class JpaHandlingEventRepository(
    EntityManager entityManager
) satisfies HandlingEventRepository{

    function events(TrackingId trackingId)
            => entityManager
                .createNamedQuery("HandlingEvent.findByTrackingId", `HandlingEvent`)
                .setParameter("trackingId", trackingId)
                .resultList;

    store(HandlingEvent event) => entityManager.persist(event);

    lookupHandlingHistoryOfCargo(TrackingId trackingId)
            => HandlingHistory(CeylonList(events(trackingId)));

}