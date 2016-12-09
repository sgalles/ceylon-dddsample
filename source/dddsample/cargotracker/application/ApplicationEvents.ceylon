import dddsample.cargotracker.domain.model.cargo {
    Cargo
}
import dddsample.cargotracker.domain.model.handling {
    HandlingEvent
}
import dddsample.cargotracker.interfaces.handling {
    HandlingEventRegistrationAttempt
}

"""
   This interface provides a way to let other parts of the system know about
   events that have occurred.
   It may be implemented synchronously or asynchronously, using for example JMS.
   """
shared interface ApplicationEvents {
    shared formal void cargoWasHandled(HandlingEvent event);
    shared formal void cargoWasMisdirected(Cargo cargo);
    shared formal void cargoHasArrived(Cargo cargo);
    shared formal void receivedHandlingEventRegistrationAttempt(HandlingEventRegistrationAttempt attempt);
}