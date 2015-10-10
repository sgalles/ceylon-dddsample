import dddsample.cargotracker.application.util {
	toJavaList
}
import dddsample.cargotracker.interfaces.booking.facade {
	BookingServiceFacade
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
	CargoRoute,
	Location
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
shared class ChangeDestination(){
	
	inject
	late BookingServiceFacade bookingServiceFacade;
	
	variable CargoRoute? _cargo = null;
	variable JList<Location>? _locations = null;
	
	
	shared variable String? trackingId = null;
	
	shared variable String? destinationUnlocode = null;
	
	shared CargoRoute? cargo => _cargo;
	
	shared JList<Location>? locations => _locations;
	
	shared void load() {
		assert(exists trackingId = trackingId);
		_locations = toJavaList(bookingServiceFacade.listShippingLocations());        
		_cargo = bookingServiceFacade.loadCargoForRouting(trackingId);
	}
	
	shared String changeDestination() {
		assert(
			exists trackingId = trackingId, 
			exists destinationUnlocode = destinationUnlocode
		);
		bookingServiceFacade.changeDestination(trackingId, destinationUnlocode);
		return "show.xhtml?faces-redirect=true&trackingId=``trackingId``";
	}
	
	
}