import dddsample.cargotracker.application.util {
	toJavaList
}
import dddsample.cargotracker.interfaces.booking.facade {
	BookingServiceFacade
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
	CargoRoute
}

import java.io {
	Serializable
}
import java.util {
	JList=List
}

import javax.annotation {
	postConstruct
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
shared class ListCargo() satisfies Serializable{
	
	late List<CargoRoute> _cargos;
	
	inject
	late BookingServiceFacade bookingServiceFacade;
	
	suppressWarnings("unusedDeclaration")
	postConstruct
	void init() {
		_cargos = bookingServiceFacade.listAllCargos();
	}
	
	shared JList<CargoRoute> cargos => toJavaList(_cargos);
	
	JList<CargoRoute> filter(Boolean(CargoRoute) predicate) => toJavaList(_cargos.filter(predicate));
	
	shared JList<CargoRoute> routedCargos => filter(CargoRoute.routed);
	
	shared JList<CargoRoute> notRoutedCargos => filter(not(CargoRoute.routed));
	
	shared JList<CargoRoute> claimedCargos => filter(CargoRoute.claimed);
	
	
	
}