import dddsample.cargotracker.application.util {
	toDate
}
import dddsample.cargotracker.domain.model.location {
	Location
}

import java.io {
	Serializable
}
import java.util {
	Date
}

import javax.persistence {
	entity,
	namedQuery,
	id__FIELD,
	generatedValue__FIELD,
	embedded__FIELD
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
	Integer? id = null;

	embedded__FIELD
	shared VoyageNumber voyageNumber;
	
	embedded__FIELD
	shared Schedule schedule;
	
	shared new init(VoyageNumber voyageNumber, Schedule schedule){
		this.voyageNumber = voyageNumber;
		this.schedule = schedule;
	}
	
	
	shared new () extends init(VoyageNumber(""), Schedule.empty){}
	
	
	shared new build(VoyageNumber voyageNumber, Location departureLocation, MovementStep+ movementSteps){
		this.voyageNumber = voyageNumber;
		
		CarrierMovement collectingCarrierMovement([Location|MovementStep, MovementStep] pair) 
				=> let( [departureStep, arrivalStep] = pair,
						departureLocation = if(is Location departureStep)  then departureStep else departureStep.arrivalLocation
					)
					CarrierMovement(departureLocation, 
									arrivalStep.arrivalLocation, 
									arrivalStep.departureTime,
									arrivalStep.departureTime);
		
		{CarrierMovement+} collectedCarrierMovement 
				= zipPairs(movementSteps.follow(departureLocation), movementSteps)
				  .map(collectingCarrierMovement);
				
		this.schedule = Schedule.init(collectedCarrierMovement);
							
	}
			
	
	
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
	
	/*public final static Voyage v100 = new Voyage.Builder(
		new VoyageNumber("V100"), HONGKONG)
			.addMovement(TOKYO, toDate("2014-03-03"), toDate("2014-03-05"))
			.addMovement(NEWYORK, toDate("2014-03-06"), toDate("2014-03-09"))
			.build();*/
	
	shared new v100 extends build(
				VoyageNumber("V100"), 
				Location.hongkong, 
				MovementStep(Location.tokyo, toDate("2014-03-03"), toDate("2014-03-05")),
				MovementStep(Location.newyork, toDate("2014-03-06"), toDate("2014-03-09"))
			){}
	
}


shared class MovementStep(shared Location arrivalLocation, shared Date departureTime, shared Date arrivalTime){}