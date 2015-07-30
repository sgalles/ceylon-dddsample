import dddsample.cargotracker.application.util {
	toDate
}
import dddsample.cargotracker.domain.model.location {
	Location
}

import java.io {
	Serializable
}
import java.lang {
	Long
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
	Long? id = null;

	embedded__FIELD
	shared VoyageNumber voyageNumber;
	
	embedded__FIELD
	shared Schedule schedule;
	
	shared new init(VoyageNumber voyageNumber, Schedule schedule){
		this.voyageNumber = voyageNumber;
		this.schedule = schedule;
	}
	
	
	shared new () extends init(VoyageNumber.init(""), Schedule.empty){}
	
	
	shared new build(VoyageNumber voyageNumber, Location departureLocation, MovementStep+ movementSteps){
		this.voyageNumber = voyageNumber;
		
		CarrierMovement collectingCarrierMovement([Location|MovementStep, MovementStep] pair) 
				=> let( [departureStep, arrivalStep] = pair,
						departureLocation = if(is Location departureStep)  then departureStep else departureStep.arrivalLocation
					)
					CarrierMovement.init(
									departureLocation, 
									arrivalStep.arrivalLocation, 
									arrivalStep.departureTime,
									arrivalStep.departureTime);
		
		{CarrierMovement+} collectedCarrierMovement 
				= zipPairs(movementSteps.follow(departureLocation), movementSteps)
				  .map(collectingCarrierMovement);
				
		this.schedule = Schedule.init(collectedCarrierMovement);
							
	}
			
	
	shared new v100 extends build(
				VoyageNumber.init("V100"), 
				Location.hongkong, 
				MovementStep(Location.tokyo, toDate("2014-03-03"), toDate("2014-03-05")),
				MovementStep(Location.newyork, toDate("2014-03-06"), toDate("2014-03-09"))
			){}
	
	
	
	shared new hongkong_to_new_york extends build(
		VoyageNumber.init("0100S"), 
		Location.hongkong, 
		MovementStep(Location.hangzou, toDate("2013-10-01", "12:00"),toDate("2013-10-03", "14:30")),
		MovementStep(Location.tokyo, toDate("2013-10-03", "21:00"),toDate("2013-10-06", "06:15")),
		MovementStep(Location.melbourne, toDate("2013-10-06", "11:00"),toDate("2013-10-12", "11:30")),
		MovementStep(Location.newyork, toDate("2013-10-14", "12:00"),toDate("2013-10-23", "23:10"))
	){}
}


shared class MovementStep(shared Location arrivalLocation, shared Date departureTime, shared Date arrivalTime){}