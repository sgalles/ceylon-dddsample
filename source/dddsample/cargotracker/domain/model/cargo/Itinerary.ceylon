


import dddsample.cargotracker.application.util {
	toJavaList
}

import java.lang {
	Long
}
import java.util {
	Date,
	JList=List
}

import javax.persistence {
	CascadeType,
	embeddable,
	joinColumn=joinColumn__FIELD,
	oneToMany=oneToMany__FIELD,
	orderBy = orderBy__FIELD
}

shared Date endOfDays = Date(Long.\iMAX_VALUE);

embeddable
shared class Itinerary {
	
	oneToMany{cascade = {CascadeType.\iALL}; orphanRemoval = true;}
	joinColumn{name = "cargo_id";}
	//orderBy("load_time") TODO reacivate when the problem with antlr lib in war is solved
	shared JList<Leg> legs;
	
	shared new init({Leg*} legs){
		this.legs = toJavaList(legs);
	}
	
	shared new() extends init({}){}
	
	shared new empty extends init({}){}	
	
}
