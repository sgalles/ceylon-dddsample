import dddsample.cargotracker.interfaces.booking.facade {
	BookingServiceFacade
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
	CargoRoute
}

import javax.faces.view {
	viewScoped
}
import javax.inject {
	named=named__TYPE,
	inject=inject__FIELD
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
shared class CargoDetails(){
	
	variable CargoRoute? _cargo = null;
	shared variable String? trackingId = null;
	
	inject
	late BookingServiceFacade bookingServiceFacade;
	
	shared CargoRoute? cargo => _cargo;
	
	shared void load() {
		assert(exists trackingId = trackingId);
		_cargo = bookingServiceFacade.loadCargoForRouting(trackingId);
	}
	
	
	
}