import javax.xml.bind.annotation {
	xmlRootElement
}

"Transfer object for handling reports."
xmlRootElement
shared class HandlingReport(
	shared variable String completionTime,
	shared variable String trackingId,
	shared variable String eventType,
	shared variable String unLocode,
	shared variable String voyageNumber
) {
	string => "HandlingReport 
	             completionTime=``completionTime``
	             trackingId=``trackingId``
	             eventType=``eventType``
	             unLocode=``unLocode``
	             voyageNumber=``voyageNumber``
	             ";
}