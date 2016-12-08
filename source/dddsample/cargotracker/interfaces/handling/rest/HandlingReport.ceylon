
import dddsample.cargotracker.domain.model.handling {
	HandlingEventTypeRequiredVoyage,
	HandlingEventTypeBundle,
	HandlingEventType,
	HandlingEventTypeProhibitedVoyage
}
import dddsample.cargotracker.domain.model.voyage {
	VoyageNumber
}

import javax.xml.bind.annotation {
	xmlRootElement
}
import dddsample.cargotracker.infrastructure.ceylon {
    caseValueByName
}

"Transfer object for handling reports."
xmlRootElement
shared class HandlingReport(
	shared variable String completionTime,
	shared variable String trackingId,
	shared variable String eventType,
	shared variable String unLocode,
	shared variable String? voyageNumber
) {
	
	
	
	shared HandlingEventTypeBundle<VoyageNumber> voyageBundle() {
		
		value handlingEventType = caseValueByName(`HandlingEventType`, eventType.lowercased);
		
		if(exists voyageNumber = voyageNumber){
			assert(is HandlingEventTypeRequiredVoyage eventType = handlingEventType);
			return [eventType, VoyageNumber(voyageNumber)];
		}else{
			assert(is HandlingEventTypeProhibitedVoyage eventType = handlingEventType);
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
