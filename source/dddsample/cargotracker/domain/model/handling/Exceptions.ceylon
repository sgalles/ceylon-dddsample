import dddsample.cargotracker.domain.model.cargo {
    TrackingId
}
import dddsample.cargotracker.domain.model.location {
    UnLocode
}
import dddsample.cargotracker.domain.model.voyage {
    VoyageNumber
}

import javax.ejb {
    applicationException
}

applicationException{rollback=true;}
shared class CannotCreateHandlingEventException(String? description=null, Throwable? cause=null) 
        extends Exception(description,cause) {}

shared class UnknownCargoException(shared TrackingId trackingId) 
        extends CannotCreateHandlingEventException(
            "No cargo with tracking id ``trackingId`` exists in the system") {}

shared class UnknownLocationException(shared UnLocode unlocode) 
        extends CannotCreateHandlingEventException(
    "No location with UN locode ``unlocode`` exists in the system") {}

shared class UnknownVoyageException(shared VoyageNumber voyageNumber) 
        extends CannotCreateHandlingEventException(
    "No voyage with number ``voyageNumber`` exists in the system") {}
