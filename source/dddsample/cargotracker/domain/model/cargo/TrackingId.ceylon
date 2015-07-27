import java.io {
	Serializable
}

import javax.persistence {
	embeddable,
	column__FIELD
}

"""
   Uniquely identifies a particular cargo. Automatically generated by the
   application.
""" 
embeddable
shared class TrackingId(idString) satisfies Serializable{
	
	column__FIELD{name = "tracking_id"; unique = true; updatable = false;}
	shared String idString;
}