import dddsample.cargotracker.domain.model.cargo {
	CargoRepository,
	TrackingId,
	Cargo
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEventRepository,
	HandlingEvent
}

import java.io {
	Serializable
}

import javax.faces.view {
	viewScoped
}
import javax.inject {
	named__TYPE,
	inject__SETTER
}


named__TYPE
viewScoped
shared class Track() satisfies Serializable{
	
	inject__SETTER
	late CargoRepository cargoRepository;
	
	inject__SETTER
	late HandlingEventRepository handlingEventRepository;
	
	variable String? _trackingId = null;
	shared String? trackingId => _trackingId;
	assign trackingId {
		_trackingId = trackingId?.trimmed;
	}
	
	shared variable CargoTrackingViewAdapter? cargo = null;
		
	shared void onTrackById(){
		assert(exists trackingId = trackingId);
		Cargo? cargo = cargoRepository.find(TrackingId(trackingId));
		if(exists cargo){
			List<HandlingEvent> handlingEvents = handlingEventRepository
					.lookupHandlingHistoryOfCargo(TrackingId(trackingId))
					.distinctEventsByCompletionTime;
			this.cargo = CargoTrackingViewAdapter(cargo, handlingEvents);
		}else{
			throw Exception("not implemented");
		}
		
		//print("On try by id ``trackingId else nothing``");
		//cargo = CargoTrackingViewAdapter();
	}
	
}