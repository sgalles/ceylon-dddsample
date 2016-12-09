import dddsample.cargotracker.interfaces.booking.facade {
    BookingServiceFacade
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
    Location
}

import java.text {
    SimpleDateFormat
}
import java.util {
    JList=List,
    Arrays
}

import javax.annotation {
    postConstruct
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
shared class Registration(BookingServiceFacade bookingServiceFacade) {

    value format = SimpleDateFormat("yyyy-MM-dd");

    shared late JList<Location> locations;

    shared variable String? arrivalDeadline = null;
    shared variable String? originUnlocode = null;
    shared variable String? destinationUnlocode = null;

    suppressWarnings("unusedDeclaration")
    postConstruct
    void init() => locations = Arrays.asList(*bookingServiceFacade.listShippingLocations());

    shared String? register() {
        assert(    exists arrivalDeadline = arrivalDeadline,
                exists originUnlocode = originUnlocode,
                exists destinationUnlocode = destinationUnlocode);

        if (originUnlocode != destinationUnlocode){
            value trackingId = bookingServiceFacade.bookNewCargo {
                origin = originUnlocode;
                destination = destinationUnlocode;
                arrivalDeadline = format.parse(arrivalDeadline);
            };
            return "show.xhtml?faces-redirect=true&trackingId=``trackingId``";
        }
        else {
            value message = FacesMessage("Origin and destination cannot be the same.");
            message.severity = FacesMessage.severityError;
            FacesContext.currentInstance.addMessage(null, message);
            return null;
        }
    }


}