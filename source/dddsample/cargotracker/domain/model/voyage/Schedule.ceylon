import ceylon.collection {
	ArrayList
}
import ceylon.interop.java {
	JavaList,
	CeylonList
}

import java.io {
	Serializable
}
import java.util {
	JList=List
}

import javax.persistence {
	embeddable,
	access,
	AccessType,
	CascadeType,
	oneToMany = oneToMany__GETTER,
	joinColumn = joinColumn__GETTER,
	transient = transient__GETTER
}

"""
   United nations location code.
   http://www.unece.org/cefact/locode/
   http://www.unece.org/cefact/locode/DocColumnDescription.htm#LOCODE   
   """
embeddable
access(AccessType.\iPROPERTY)
shared class Schedule  satisfies Serializable{
	

	transient
	shared variable List<CarrierMovement> _carrierMovements;
	
	_carrierMovements = ArrayList();
	
	shared new(){
		_carrierMovements = ArrayList();
	}
	
	shared new init({CarrierMovement+} carrierMovements){
		_carrierMovements = ArrayList{*carrierMovements};
	}
	
	oneToMany{cascade = { CascadeType.\iALL }; orphanRemoval = true;}
	joinColumn{name = "voyage_id";}
	shared JList<CarrierMovement> carrierMovements => JavaList(_carrierMovements);
	
	assign carrierMovements{
		_carrierMovements = CeylonList(carrierMovements);
	}
	
	// null object pattern
	shared new empty extends Schedule(){}
	
	
}