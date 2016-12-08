import dddsample.cargotracker.domain.model.handling {
    HandlingEventTypeRequiredVoyage,
    HandlingEventTypeBundle,
    HandlingEventType,
    HandlingEventTypeProhibitedVoyage
}
import dddsample.cargotracker.domain.model.voyage {
    VoyageNumber
}
import dddsample.cargotracker.infrastructure.ceylon {
    caseValueByName
}

import javax.xml.bind.annotation {
    xmlRootElement
}

"Transfer object for handling reports."
xmlRootElement
shared class HandlingReport(
	completionTime,
	trackingId,
	eventType,
	unLocode,
	voyageNumber
) {

	shared String completionTime;
	shared String trackingId;
	shared String eventType;
	shared String unLocode;
	shared String? voyageNumber;

	shared HandlingEventTypeBundle<VoyageNumber> voyageBundle() {

		assert (exists eventType = caseValueByName(`HandlingEventType`, eventType));

		switch (eventType)
		case (is HandlingEventTypeRequiredVoyage) {
			assert (exists voyageNumber = voyageNumber);
			return [eventType, VoyageNumber(voyageNumber)];
		}
		case (is HandlingEventTypeProhibitedVoyage) {
			return eventType;
		}
	}

	string => "HandlingReport 
	             completionTime=``completionTime``
	             trackingId=``trackingId``
	             eventType=``eventType``
	             unLocode=``unLocode``
	             voyageNumber=``voyageNumber else "<null>"``
	             ";
}
