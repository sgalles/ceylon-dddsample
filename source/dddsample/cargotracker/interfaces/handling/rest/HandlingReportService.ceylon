import dddsample.cargotracker.application {
	ApplicationEvents
}
import dddsample.cargotracker.domain.model.cargo {
	TrackingId
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEventTypeBundle
}
import dddsample.cargotracker.domain.model.location {
	UnLocode
}
import dddsample.cargotracker.domain.model.voyage {
	VoyageNumber
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
	inject=inject__SETTER
}
import javax.ws.rs {
	path,
	post,
	consumes
}
import javax.ws.rs.core {
	MediaType
}

import org.slf4j {
	Logger
}

String iso8601format = "yyyy-MM-dd HH:mm";

path("/handling")
shared class HandlingReportService() {
	
	inject
	late ApplicationEvents applicationEvents;
	
	inject
	late Logger log;
	
	post
	path("/reports")
	consumes({MediaType.\iAPPLICATION_JSON})
	shared void submitReport(HandlingReport handlingReport) {
		
		Date completionTime = SimpleDateFormat(iso8601format).parse(handlingReport.completionTime);
		HandlingEventTypeBundle<VoyageNumber> voyageBundle = handlingReport.voyageBundle();
		UnLocode unLocode = UnLocode(handlingReport.unLocode);
		TrackingId trackingId = TrackingId(handlingReport.trackingId);
		Date registrationTime = Date();
		
		HandlingEventRegistrationAttempt attempt =
				HandlingEventRegistrationAttempt(registrationTime,
			completionTime, trackingId, voyageBundle, unLocode);
		applicationEvents.receivedHandlingEventRegistrationAttempt(attempt);
	}
	
}
