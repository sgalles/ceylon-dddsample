import dddsample.cargotracker.application.util {
	toJavaList
}

import java.io {
	Serializable
}
import java.util {
	JList=List,
	JArrayList=ArrayList
}

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
shared class Schedule  satisfies Serializable{
	
	oneToMany{cascade = { CascadeType.\iALL }; orphanRemoval = true;}
	joinColumn{name = "voyage_id";}
	shared variable JList<CarrierMovement> carrierMovements;
	
	shared new(){
		this.carrierMovements = JArrayList<CarrierMovement>();
	}
	
	shared new init({CarrierMovement+} carrierMovements){
		this.carrierMovements = toJavaList(carrierMovements);
	}
	
	// null object pattern
	shared new empty extends Schedule(){}
	
	
	
	
	
	
	
}