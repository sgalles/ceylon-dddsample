

import java.util {
	JList=List
}

import javax.persistence {
	embeddable,
	CascadeType,
	oneToMany=oneToMany__FIELD,
	joinColumn=joinColumn__FIELD
}
import dddsample.cargotracker.infrastructure.ceylon {

	toJavaList
}

"""
   United nations location code.
   http://www.unece.org/cefact/locode/
   http://www.unece.org/cefact/locode/DocColumnDescription.htm#LOCODE   
   """
embeddable
shared class Schedule({CarrierMovement+} carrierMovementSeq){
	
	oneToMany{cascade = { CascadeType.\iALL }; orphanRemoval = true;}
	joinColumn{name = "voyage_id";}
	shared variable JList<CarrierMovement> carrierMovements = toJavaList(carrierMovementSeq);
	
	
}