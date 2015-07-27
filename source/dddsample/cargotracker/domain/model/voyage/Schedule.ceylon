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
shared class Schedule()  satisfies Serializable{
	
	//shared new(){
		
	//}
	
	// null object pattern
	//shared new unknown extends Schedule(){}
	
	//private List<CarrierMovement> carrierMovements = Collections.emptyList();
	
	/*column__FIELD
	String unlocode;*/
	
	
	
	//shared String idString => unlocode;
	
}