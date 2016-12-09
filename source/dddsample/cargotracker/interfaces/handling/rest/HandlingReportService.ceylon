import dddsample.cargotracker.application {
    ApplicationEvents
}
import dddsample.cargotracker.domain.model.cargo {
    TrackingId
}
import dddsample.cargotracker.domain.model.location {
    UnLocode
}
import dddsample.cargotracker.interfaces.handling {
    HandlingEventRegistrationAttempt
}

import java.text {
    SimpleDateFormat
}
import java.util {
    Date
}

import javax.inject {
    inject
}
import javax.ws.rs {
    path,
    post,
    consumes
}
import javax.ws.rs.core {
    MediaType
}


path("/handling")
shared class HandlingReportService() {

    value iso8601format = SimpleDateFormat("yyyy-MM-dd HH:mm");

    inject
    late ApplicationEvents applicationEvents;

    post
    path("/reports")
    consumes {MediaType.applicationJson}
    shared void submitReport(HandlingReport handlingReport) {

        value attempt =
                HandlingEventRegistrationAttempt {
                    registrationTime = Date();
                    completionTime = iso8601format.parse(handlingReport.completionTime);
                    trackingId = TrackingId(handlingReport.trackingId);
                    typeAndVoyage = handlingReport.voyageBundle();
                    unLocode = UnLocode(handlingReport.unLocode);
                };
        applicationEvents.receivedHandlingEventRegistrationAttempt(attempt);
    }

}
