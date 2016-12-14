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

        HandlingEventType eventTypeEnum = HandlingEventType.enums.getValue(eventType);

        switch (eventTypeEnum)
        case (is HandlingEventTypeRequiredVoyage) {
            assert (exists voyageNumber = voyageNumber);
            return [eventTypeEnum, VoyageNumber(voyageNumber)];
        }
        case (is HandlingEventTypeProhibitedVoyage) {
            return eventTypeEnum;
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
