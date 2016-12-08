import javax.persistence {
	embeddable,
	column
}

"""
   Uniquely identifies a particular cargo. Automatically generated by the
   application.
""" 
embeddable
shared class TrackingId(idString){
	
	column{name = "tracking_id"; unique = true; updatable = false;}
	shared String idString;

}