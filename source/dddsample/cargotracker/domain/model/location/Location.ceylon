import java.lang {
	Long
}

import javax.persistence {
	entity,
	namedQueries,
	namedQuery,
	id,
	generatedValue,
	embedded
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
	
	shared new (UnLocode unLocode, String name){
		this.unLocode = unLocode;
		this.name = name;
	}
	
	shared new unknown extends Location(UnLocode("XXXXX"), "Unknown location"){}
	
	shared new hongkong extends Location(UnLocode("CNHKG"), "Hong Kong"){}
	shared new melbourne extends Location(UnLocode("AUMEL"), "Melbourne"){}
	shared new stockholm extends Location(UnLocode("SESTO"), "Stockholm"){}
	shared new helsinki extends Location(UnLocode("FIHEL"), "Helsinki"){}
	shared new chicago extends Location(UnLocode("USCHI"), "Chicago"){}
	shared new tokyo extends Location(UnLocode("JNTKO"), "Tokyo"){}
	shared new hamburg extends Location(UnLocode("DEHAM"), "Hamburg"){}
	shared new shanghai extends Location(UnLocode("CNSHA"), "Shanghai"){}
	shared new rotterdam extends Location(UnLocode("NLRTM"), "Rotterdam"){}
	shared new gothenburg extends Location(UnLocode("SEGOT"), "Guttenburg"){}
	shared new hangzou extends Location(UnLocode("CNHGH"), "Hangzhou"){}
	shared new newyork extends Location(UnLocode("USNYC"), "New York"){}
	shared new dallas extends Location(UnLocode("USDAL"), "Dallas"){}
	
	shared Boolean sameIdentityAs(Location? other) 
			=> if(exists other) then this.unLocode.sameValueAs(other.unLocode) else false;
	
}