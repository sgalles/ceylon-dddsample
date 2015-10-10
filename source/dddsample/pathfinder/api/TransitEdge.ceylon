import java.util {
	Date
}
shared class TransitEdge(
	shared variable String voyageNumber,
	shared variable String fromUnLocode,
	shared variable String toUnLocode,
	shared variable Date fromDate,
	shared variable Date toDate
) {
	string =>"""TransitEdge{
	            voyageNumber=``voyageNumber``,
	            fromUnLocode=``fromUnLocode``,
	            toUnLocode=``toUnLocode``,
	            fromDate=``fromDate``,
	            toDate=``toDate``}""";
}