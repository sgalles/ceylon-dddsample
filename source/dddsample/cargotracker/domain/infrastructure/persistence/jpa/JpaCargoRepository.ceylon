import dddsample.cargotracker.domain.model.cargo {
	CargoRepository,
	Cargo,
	TrackingId
}

import java.io {
	Serializable
}
class JpaCargoRepository() satisfies CargoRepository & Serializable{
	
	shared actual Cargo? find(TrackingId trackingId) => Cargo();
	
	shared actual List<Cargo> findAll() => nothing;
	
	shared actual TrackingId nextTrackingId() => nothing;
	
	shared actual void store(Cargo cargo) {}
	
}