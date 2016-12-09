import java.util {
    Date
}

shared class TransitEdge(
    shared String voyageNumber,
    shared String fromUnLocode,
    shared String toUnLocode,
    shared Date fromDate,
    shared Date toDate
) {
    string =>"""TransitEdge{
                voyageNumber=``voyageNumber``,
                fromUnLocode=``fromUnLocode``,
                toUnLocode=``toUnLocode``,
                fromDate=``fromDate``,
                toDate=``toDate``}""";
}