import dddsample.cargotracker.application {
	ApplicationEvents
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

path("/handling")
shared class HandlingReportService() {
	
	String iso8601format = "yyyy-MM-dd HH:mm";
	
	inject
	late ApplicationEvents applicationEvents;
	
	inject
	late Logger log;
	
	post
	path("/reports")
	consumes({MediaType.\iAPPLICATION_JSON})
	shared default void submitReport(HandlingReport handlingReport) {
		log.info(handlingReport.string);
	}
	
}
