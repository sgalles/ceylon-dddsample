import java.lang {
	Long
}

import javax.persistence {
	entity,
	namedQueries,
	namedQuery,
	id=id__FIELD,
	generatedValue=generatedValue__FIELD,
	embedded=embedded__FIELD
}


"""
   A location in our model is stops on a journey, such as cargo origin or
   destination, or carrier movement end points.
   
   It is uniquely identified by a UN location code.
   
"""
entity
namedQueries({
	namedQuery{name = "Location.findAll";
		query = "Select l from Location l";},
		namedQuery{name = "Location.findByUnLocode";
			query = "Select l from Location l where l.unLocode = :unLocode";}	
		}) 
shared class Location {
	
	id
	generatedValue
	shared Long? id = null;

	embedded
	shared UnLocode unLocode;
	
	shared String name;
	
	shared new init(UnLocode unLocode, String name){
		this.unLocode = unLocode;
		this.name = name;
	}
	
	shared new () extends init(UnLocode(),""){}
	


	shared new unknown extends init(UnLocode.withCountryAndLocation("XXXXX"), "Unknown location"){}
	
	shared new hongkong extends init(UnLocode.withCountryAndLocation("CNHKG"), "Hong Kong"){}
	shared new melbourne extends init(UnLocode.withCountryAndLocation("AUMEL"), "Melbourne"){}
	shared new stockholm extends init(UnLocode.withCountryAndLocation("SESTO"), "Stockholm"){}
	shared new helsinki extends init(UnLocode.withCountryAndLocation("FIHEL"), "Helsinki"){}
	shared new chicago extends init(UnLocode.withCountryAndLocation("USCHI"), "Chicago"){}
	shared new tokyo extends init(UnLocode.withCountryAndLocation("JNTKO"), "Tokyo"){}
	shared new hamburg extends init(UnLocode.withCountryAndLocation("DEHAM"), "Hamburg"){}
	shared new shanghai extends init(UnLocode.withCountryAndLocation("CNSHA"), "Shanghai"){}
	shared new rotterdam extends init(UnLocode.withCountryAndLocation("NLRTM"), "Rotterdam"){}
	shared new gothenburg extends init(UnLocode.withCountryAndLocation("SEGOT"), "Guttenburg"){}
	shared new hangzou extends init(UnLocode.withCountryAndLocation("CNHGH"), "Hangzhou"){}
	shared new newyork extends init(UnLocode.withCountryAndLocation("USNYC"), "New York"){}
	shared new dallas extends init(UnLocode.withCountryAndLocation("USDAL"), "Dallas"){}
	
	shared Boolean sameIdentityAs(Location other) 
			=> this.unLocode.sameValueAs(other.unLocode);
	
}