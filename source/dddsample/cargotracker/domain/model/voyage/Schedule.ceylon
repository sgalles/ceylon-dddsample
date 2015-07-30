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
	JList=List,
	JArrayList = ArrayList
}

import javax.persistence {
	embeddable,
	access,
	AccessType,
	CascadeType,
	oneToMany=oneToMany__GETTER,
	joinColumn=joinColumn__GETTER,
	transient__FIELD,
	transient__SETTER,
	transient__GETTER
}

"""
   United nations location code.
   http://www.unece.org/cefact/locode/
   http://www.unece.org/cefact/locode/DocColumnDescription.htm#LOCODE   
   """
embeddable
access(AccessType.\iPROPERTY)
shared class Schedule  satisfies Serializable{
	
	oneToMany{cascade = { CascadeType.\iALL }; orphanRemoval = true;}
	joinColumn{name = "voyage_id";}
	shared variable JList<CarrierMovement> carrierMovements;
	
	shared new(){
		this.carrierMovements = JArrayList<CarrierMovement>();
	}
	
	shared new init({CarrierMovement+} carrierMovements){
		this.carrierMovements = 
				let (ceylonList = ArrayList{*carrierMovements}) 
				JArrayList<CarrierMovement>(JavaList(ceylonList));
	}
	
	// null object pattern
	shared new empty extends Schedule(){}
	
	
	
	
	
	
	
}