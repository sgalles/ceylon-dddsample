

import javax.persistence {
	embeddable,
	CascadeType,
	oneToMany=oneToMany__FIELD,
	joinColumn=joinColumn__FIELD
}

"""
   United nations location code.
   http://www.unece.org/cefact/locode/
   http://www.unece.org/cefact/locode/DocColumnDescription.htm#LOCODE   
   """
embeddable
shared class Schedule(carrierMovements){
	
	oneToMany{cascade = { CascadeType.\iALL }; orphanRemoval = true;}
	joinColumn{name = "voyage_id";}
	shared variable List<CarrierMovement> carrierMovements;
	
	
}