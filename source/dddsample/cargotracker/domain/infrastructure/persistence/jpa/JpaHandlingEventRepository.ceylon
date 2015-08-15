
import dddsample.cargotracker.domain.model.cargo {
	TrackingId
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEventRepository,
	HandlingHistory,
	HandlingEvent
}

import java.io {
	Serializable
}
class JpaHandlingEventRepository() satisfies HandlingEventRepository & Serializable{
	shared actual HandlingHistory lookupHandlingHistoryOfCargo(TrackingId trackingId) 
			=> HandlingHistory.empty;
	
	shared actual void store(HandlingEvent event) {}
	
}