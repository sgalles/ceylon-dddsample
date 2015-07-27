import java.io {
	Serializable
}

import javax.persistence {
	embeddable,
	column__FIELD
}
"""
   United nations location code.
   http://www.unece.org/cefact/locode/
   http://www.unece.org/cefact/locode/DocColumnDescription.htm#LOCODE   
   """
embeddable
shared class UnLocode  satisfies Serializable{
	
	column__FIELD
	String unlocode;
	
	shared new(){
		unlocode = "";
	}
	shared new withCountryAndLocation(String countryAndLocation){
		unlocode = countryAndLocation.uppercased;
	}
	
	
	shared String idString => unlocode;
	
}