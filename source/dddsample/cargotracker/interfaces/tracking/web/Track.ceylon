import dddsample.cargotracker.domain.model.cargo {
    CargoRepository,
    TrackingId
}
import dddsample.cargotracker.domain.model.handling {
    HandlingEventRepository
}

import javax.faces.application {
    FacesMessage
}
import javax.faces.context {
    FacesContext
}
import javax.faces.view {
    viewScoped
}
import javax.inject {
    named=named__TYPE,
    inject
}

named
viewScoped
inject
shared class Track(
	CargoRepository cargoRepository,
	HandlingEventRepository handlingEventRepository
){
	
	variable String? _trackingId = null;
	shared String? trackingId => _trackingId;
	assign trackingId {
		_trackingId = trackingId?.trimmed;
	}
	
	shared variable CargoTrackingViewAdapter? cargo = null;
		
	shared void onTrackById() {
		assert (exists trackingId = trackingId);

		if (exists cargo = cargoRepository.find(TrackingId(trackingId))) {
			this.cargo = CargoTrackingViewAdapter {
			    cargo = cargo;
			    handlingEvents
						= handlingEventRepository
						.lookupHandlingHistoryOfCargo(TrackingId(trackingId))
						.distinctEventsByCompletionTime;
			};
		}
		else {
			value context = FacesContext.currentInstance;
			value message = FacesMessage("Cargo with tracking ID: ``trackingId``  not found.");
			message.severity = FacesMessage.severityError;
			context.addMessage(null, message);
			this.cargo = null;
		}
		
	}
	
}