


import dddsample.cargotracker.application.util {
	toJavaList
}
import dddsample.cargotracker.domain.model.location {
	Location
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
	oneToMany=oneToMany__FIELD
}
import ceylon.interop.java {

	CeylonList
}

shared Date endOfDays = Date(Long.\iMAX_VALUE);

embeddable
shared class Itinerary {
	
	oneToMany{cascade = {CascadeType.\iALL}; orphanRemoval = true;}
	joinColumn{name = "cargo_id";}
	//orderBy("load_time") TODO reactivate when the problem with antlr lib in war is solved
	shared JList<Leg> _legs;
	
	shared new init({Leg*} legs){
		this._legs = toJavaList(legs);
	}
	
	shared new() extends init({}){}
	
	shared new empty extends init({}){}
	
	[Leg*] legs() => CeylonList(_legs).sequence();
	
	shared Location initialDepartureLocation() 
			=> if(nonempty legs = legs()) then legs.first.loadLocation else Location.unknown;	
	
	shared Location finalArrivalLocation() 
			=> if(nonempty legs = legs()) then legs.last.unloadLocation else Location.unknown;	
	
	shared Date finalArrivalDate() 
			=> let(time = if(nonempty legs = legs()) then legs.last.unloadTime.time else endOfDays.time)
			   Date(time);
	
	
	
	
}
