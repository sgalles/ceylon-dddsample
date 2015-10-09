import dddsample.cargotracker.interfaces.booking.facade {
	BookingServiceFacade
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
	CargoRoute,
	Location,
	RouteCandidate
}

import java.util {
	JList=List
}

import javax.faces.view {
	viewScoped
}
import javax.inject {
	named=named__TYPE,
	inject=inject__FIELD
}
import dddsample.cargotracker.application.util {

	toJavaList
}

"""
   Handles listing cargo. Operates against a dedicated service facade, and could
   easily be rewritten as a thick Swing client. Completely separated from the
   domain layer, unlike the tracking user interface.
   In order to successfully keep the domain model shielded from user interface
   considerations, this approach is generally preferred to the one taken in the
   tracking controller. However, there is never any one perfect solution for all
   situations, so we've chosen to demonstrate two polarized ways to build user
   interfaces.
   """
named
viewScoped
shared class ItinerarySelection(){
	
	inject
	late BookingServiceFacade bookingServiceFacade;
	
	variable CargoRoute? _cargo = null;
	variable JList<RouteCandidate>? _routeCandidates = null;
	shared variable String? trackingId = null;
	
	shared CargoRoute? cargo => _cargo;
	
	shared JList<RouteCandidate>? routeCandidates => _routeCandidates;
	
	shared void load() {
		assert(exists trackingId = trackingId);
		_cargo = bookingServiceFacade.loadCargoForRouting(trackingId);
		_routeCandidates = toJavaList(bookingServiceFacade.requestPossibleRoutesForCargo(trackingId));
	}
	
	shared String assignItinerary(Integer routeIndex) {
		assert (exists trackingId = trackingId, 
				exists _routeCandidates = _routeCandidates);
		RouteCandidate route = _routeCandidates.get(routeIndex);
		bookingServiceFacade.assignCargoToRoute(trackingId, route);
		
		return "show.html?faces-redirect=true&trackingId=" + trackingId;
	}
	
}