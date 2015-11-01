import dddsample.cargotracker.application.util {
	caseValues
}
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
import ceylon.language.meta {

	type
}
import ceylon.collection {

	HashMap
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
		
		// TODO use same transformation code both for this and JPA Converters. Cavest : there's a 'lowercased' here
		value enums = caseValues<HandlingEventType>();
		HandlingEventType?(String&Object) getEnumValueByName
				= HashMap{*enums.map((ts) => type(ts).declaration.name.lowercased->ts)}.get;
		HandlingEventType? handlingEventType = getEnumValueByName(eventType.lowercased);
		
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
