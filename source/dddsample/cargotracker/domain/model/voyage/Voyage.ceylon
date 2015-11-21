import dddsample.cargotracker.application.util {
	toDate
}
import dddsample.cargotracker.domain.model.location {
	Location
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
namedQuery{name = "Voyage.findByVoyageNumber";
	query = "Select v from Voyage v where v.voyageNumber = :voyageNumber";}
shared class Voyage{
	
	suppressWarnings("unusedDeclaration")
	id
	generatedValue
	Long? id = null;

	embedded
	shared VoyageNumber voyageNumber;
	
	embedded
	shared Schedule schedule;
	
	shared new (VoyageNumber voyageNumber, Schedule schedule){
		this.voyageNumber = voyageNumber;
		this.schedule = schedule;
	}
	
	
	
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
				
		this.schedule = Schedule(collectedCarrierMovement);
							
	}
	
	
			

	shared new v100 extends build(
				VoyageNumber("V100"), 
				Location.hongkong, 
				MovementStep(Location.tokyo, toDate("2014-03-03"), toDate("2014-03-05")),
				MovementStep(Location.newyork, toDate("2014-03-06"), toDate("2014-03-09"))
			){}
	
	
	
	shared new hongkong_to_new_york extends build(
		VoyageNumber("0100S"),Location.hongkong, 
		MovementStep(Location.hangzou, toDate("2013-10-01", "12:00"),toDate("2013-10-03", "14:30")),
		MovementStep(Location.tokyo, toDate("2013-10-03", "21:00"),toDate("2013-10-06", "06:15")),
		MovementStep(Location.melbourne, toDate("2013-10-06", "11:00"),toDate("2013-10-12", "11:30")),
		MovementStep(Location.newyork, toDate("2013-10-14", "12:00"),toDate("2013-10-23", "23:10"))
	){}
	
	shared new new_york_to_dallas extends build(
		VoyageNumber("0200T"), Location.newyork, 
		MovementStep(Location.chicago, toDate("2013-10-24", "07:00"), toDate("2013-10-24", "17:45")),
		MovementStep(Location.dallas, toDate("2013-10-24", "21:25"), toDate("2013-10-25", "19:30"))
	){}
	
	shared new dallas_to_helsinki extends build(
		VoyageNumber("0300A"),Location.dallas, 
		MovementStep(Location.hamburg, toDate("2013-10-29", "03:30"), toDate("2013-10-31", "14:00")),
		MovementStep(Location.stockholm, toDate("2013-11-01", "15:20"), toDate("2013-11-01", "18:40")),
		MovementStep(Location.helsinki, toDate("2013-11-02", "09:00"), toDate("2013-11-02", "11:15"))
	){}
	
	shared new dallas_to_helsinki_alt extends build(
		VoyageNumber("0301S"), Location.dallas, 
		MovementStep(Location.helsinki, toDate("2013-10-29", "03:30"), toDate("2013-11-05", "15:45"))
	){}
	
	shared new helsinki_to_hongkong extends build(
		VoyageNumber("0400S"),Location.dallas, 
		MovementStep(Location.rotterdam, toDate("2013-11-04", "05:50"), toDate("2013-11-06", "14:10")),
		MovementStep(Location.shanghai, toDate("2013-11-10", "21:45"), toDate("2013-11-22", "16:40")),
		MovementStep(Location.hongkong, toDate("2013-11-24", "07:00"), toDate("2013-11-28", "13:37"))
	){}
	
	shared Boolean sameIdentityAs(Voyage other) 
			=> this.voyageNumber.sameValueAs(other.voyageNumber);	
}

	

shared class MovementStep(shared Location arrivalLocation, shared Date departureTime, shared Date arrivalTime){}