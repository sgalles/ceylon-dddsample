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
	
	shared actual void store(HandlingEvent event) {
		entityManager.persist(event);
	}
	
	shared actual HandlingHistory lookupHandlingHistoryOfCargo(TrackingId trackingId) 
		=> let(jlist = 
					entityManager.createNamedQuery("HandlingEvent.findByTrackingId", `HandlingEvent`)
                	.setParameter("trackingId", trackingId).resultList
			) 
			HandlingHistory(CeylonList(jlist));
	
}