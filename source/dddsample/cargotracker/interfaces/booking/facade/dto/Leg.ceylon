import java.text {
    SimpleDateFormat
}
import java.util {
    Date
}

shared class Leg(voyageNumber, fromUnLocode, String fromName, 
                toUnLocode, toName, Date loadTimeDate, Date unloadTimeDate){

    value dateFormat = SimpleDateFormat("MM/dd/yyyy hh:mm a z");

    shared String voyageNumber;
    shared String fromUnLocode;
    shared String toUnLocode;
    shared String toName;
    shared String loadTime = dateFormat.format(loadTimeDate);
    shared String unloadTime = dateFormat.format(unloadTimeDate);

    shared String from => "``fromName`` (``fromUnLocode``)";
    shared String to => "``toUnLocode`` (``toName``)";

}