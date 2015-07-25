import dddsample.cargotracker.domain.model.cargo {
	TrackingId
}
shared interface HandlingEventRepository {
	
	shared formal void store(HandlingEvent event);
	
	shared formal HandlingHistory lookupHandlingHistoryOfCargo(TrackingId trackingId);
	
}