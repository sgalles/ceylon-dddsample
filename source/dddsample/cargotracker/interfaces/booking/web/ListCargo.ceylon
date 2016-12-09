import dddsample.cargotracker.interfaces.booking.facade {
    BookingServiceFacade
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
    CargoRoute
}

import java.util {
    JList=List,
    Arrays
}

import javax.annotation {
    postConstruct
}
import javax.faces.view {
    viewScoped
}
import javax.inject {
    named=named__TYPE,
    inject
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
inject
shared class ListCargo(BookingServiceFacade bookingServiceFacade) {

    late List<CargoRoute> _cargos;

    suppressWarnings("unusedDeclaration")
    postConstruct
    void init() => _cargos = bookingServiceFacade.listAllCargos();

    shared JList<CargoRoute> cargos => Arrays.asList(*_cargos);

    function filteredCargos(Boolean(CargoRoute) predicate) => Arrays.asList(*_cargos.filter(predicate));

    shared JList<CargoRoute> routedCargos => filteredCargos(CargoRoute.routed);

    shared JList<CargoRoute> notRoutedCargos => filteredCargos(not(CargoRoute.routed));

    shared JList<CargoRoute> claimedCargos => filteredCargos(CargoRoute.claimed);

}