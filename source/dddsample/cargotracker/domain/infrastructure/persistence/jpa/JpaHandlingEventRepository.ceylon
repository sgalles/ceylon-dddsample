import ceylon.interop.java {
	javaClass,
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

import java.io {
	Serializable
}

import javax.enterprise.context {
	applicationScoped
}
import javax.inject {
	inject=inject__FIELD
}
import javax.persistence {
	EntityManager
}


applicationScoped
class JpaHandlingEventRepository() satisfies HandlingEventRepository & Serializable{
	
	inject
	late EntityManager entityManager;
	
	
	shared actual void store(HandlingEvent event) {
		entityManager.persist(event);
	}
	
	shared actual HandlingHistory lookupHandlingHistoryOfCargo(TrackingId trackingId) 
		=> let(jlist = 
					entityManager.createNamedQuery("HandlingEvent.findByTrackingId", javaClass<HandlingEvent>())
                	.setParameter("trackingId", trackingId).resultList
			) 
			HandlingHistory(CeylonList(jlist));
	
}