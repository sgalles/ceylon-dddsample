import java.io {
	Serializable
}
import java.lang {
	Long
}

import javax.persistence {
	entity,
	namedQueries,
	namedQuery,
	id__FIELD,
	generatedValue__FIELD,
	embedded__FIELD
}
import dddsample.cargotracker.domain.model.location {

	UnLocode
}


"""
   A location in our model is stops on a journey, such as cargo origin or
   destination, or carrier movement end points.
   
   It is uniquely identified by a UN location code.
   
"""
entity
namedQuery{name = "Voyage.findByVoyageNumber";
	query = "Select v from Voyage v where v.voyageNumber = :voyageNumber";}
shared class Voyage satisfies Serializable{
	
	id__FIELD
	generatedValue__FIELD
	Long? id = null;

	embedded__FIELD
	shared VoyageNumber voyageNumber;
	
	embedded__FIELD
	shared Schedule schedule;
	
	shared new init(VoyageNumber voyageNumber, Schedule schedule){
		this.voyageNumber = voyageNumber;
		this.schedule = schedule;
	}
	
	shared new () extends init(VoyageNumber(""), Schedule.empty){}
	
	/*shared new hongkong extends Voyage.init(UnLocode.withCountryAndLocation("CNHKG"), "Hong Kong"){}
	shared new melbourne extends Voyage.init(UnLocode.withCountryAndLocation("AUMEL"), "Melbourne"){}
	shared new stockholm extends Voyage.init(UnLocode.withCountryAndLocation("SESTO"), "Stockholm"){}
	shared new helsinki extends Voyage.init(UnLocode.withCountryAndLocation("FIHEL"), "Helsinki"){}
	shared new chicago extends Voyage.init(UnLocode.withCountryAndLocation("USCHI"), "Chicago"){}
	shared new tokyo extends Voyage.init(UnLocode.withCountryAndLocation("JNTKO"), "Tokyo"){}
	shared new hamburg extends Voyage.init(UnLocode.withCountryAndLocation("DEHAM"), "Hamburg"){}
	shared new shanghai extends Voyage.init(UnLocode.withCountryAndLocation("CNSHA"), "Shanghai"){}
	shared new rotterdam extends Voyage.init(UnLocode.withCountryAndLocation("NLRTM"), "Rotterdam"){}
	shared new gothenburg extends Voyage.init(UnLocode.withCountryAndLocation("SEGOT"), "Guttenburg"){}
	shared new hangzou extends Voyage.init(UnLocode.withCountryAndLocation("CNHGH"), "Hangzhou"){}
	shared new newyork extends Voyage.init(UnLocode.withCountryAndLocation("USNYC"), "New York"){}
	shared new dallas extends Voyage.init(UnLocode.withCountryAndLocation("USDAL"), "Dallas"){}*/
	
}