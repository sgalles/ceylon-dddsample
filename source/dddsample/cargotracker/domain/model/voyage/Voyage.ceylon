import dddsample.cargotracker.domain.model.location {
    Location
}
import dddsample.cargotracker.infrastructure.ceylon {
    toDate
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
namedQuery {
    name = "Voyage.findByVoyageNumber";
    query = "Select v from Voyage v where v.voyageNumber = :voyageNumber";
}
shared class Voyage {

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

        function collectingCarrierMovement(Location|MovementStep departureStep, MovementStep arrivalStep)
                => let (departureLocation
                            = if (is Location departureStep)
                            then departureStep
                            else departureStep.arrivalLocation)
                CarrierMovement {
                    departureLocation = departureLocation;
                    arrivalLocation = arrivalStep.arrivalLocation;
                    departureTime = arrivalStep.departureTime;
                    arrivalTime = arrivalStep.departureTime;
                };

        this.schedule = Schedule {
            carrierMovements
                    = zipPairs(movementSteps.follow(departureLocation), movementSteps)
                      .map(unflatten(collectingCarrierMovement))
                    .sequence();
        };

    }

    shared new v100 extends build(
                VoyageNumber("V100"),
                Location.hongkong,
                MovementStep {
                    arrivalLocation = Location.tokyo;
                    departureTime = toDate("2014-03-03");
                    arrivalTime = toDate("2014-03-05");
                },
                MovementStep {
                    arrivalLocation = Location.newyork;
                    departureTime = toDate("2014-03-06");
                    arrivalTime = toDate("2014-03-09");
                }
            ) {}

    shared new hongkong_to_new_york extends build(
        VoyageNumber("0100S"),
        Location.hongkong,
        MovementStep {
            arrivalLocation = Location.hangzou;
            departureTime = toDate("2013-10-01", "12:00");
            arrivalTime = toDate("2013-10-03", "14:30");
        },
        MovementStep {
            arrivalLocation = Location.tokyo;
            departureTime = toDate("2013-10-03", "21:00");
            arrivalTime = toDate("2013-10-06", "06:15");
        },
        MovementStep {
            arrivalLocation = Location.melbourne;
            departureTime = toDate("2013-10-06", "11:00");
            arrivalTime = toDate("2013-10-12", "11:30");
        },
        MovementStep {
            arrivalLocation = Location.newyork;
            departureTime = toDate("2013-10-14", "12:00");
            arrivalTime = toDate("2013-10-23", "23:10");
        }
    ) {}

    shared new new_york_to_dallas extends build(
        VoyageNumber("0200T"),
        Location.newyork,
        MovementStep {
            arrivalLocation = Location.chicago;
            departureTime = toDate("2013-10-24", "07:00");
            arrivalTime = toDate("2013-10-24", "17:45");
        },
        MovementStep {
            arrivalLocation = Location.dallas;
            departureTime = toDate("2013-10-24", "21:25");
            arrivalTime = toDate("2013-10-25", "19:30");
        }
    ) {}

    shared new dallas_to_helsinki extends build(
        VoyageNumber("0300A"),
        Location.dallas,
        MovementStep {
            arrivalLocation = Location.hamburg;
            departureTime = toDate("2013-10-29", "03:30");
            arrivalTime = toDate("2013-10-31", "14:00");
        },
        MovementStep {
            arrivalLocation = Location.stockholm;
            departureTime = toDate("2013-11-01", "15:20");
            arrivalTime = toDate("2013-11-01", "18:40");
        },
        MovementStep {
            arrivalLocation = Location.helsinki;
            departureTime = toDate("2013-11-02", "09:00");
            arrivalTime = toDate("2013-11-02", "11:15");
        }
    ) {}

    shared new dallas_to_helsinki_alt extends build(
        VoyageNumber("0301S"),
        Location.dallas,
        MovementStep {
            arrivalLocation = Location.helsinki;
            departureTime = toDate("2013-10-29", "03:30");
            arrivalTime = toDate("2013-11-05", "15:45");
        }
    ) {}

    shared new helsinki_to_hongkong extends build(
        VoyageNumber("0400S"),
        Location.dallas,
        MovementStep {
            arrivalLocation = Location.rotterdam;
            departureTime = toDate("2013-11-04", "05:50");
            arrivalTime = toDate("2013-11-06", "14:10");
        },
        MovementStep {
            arrivalLocation = Location.shanghai;
            departureTime = toDate("2013-11-10", "21:45");
            arrivalTime = toDate("2013-11-22", "16:40");
        },
        MovementStep {
            arrivalLocation = Location.hongkong;
            departureTime = toDate("2013-11-24", "07:00");
            arrivalTime = toDate("2013-11-28", "13:37");
        }
    ) {}

    shared Boolean sameIdentityAs(Voyage other)
            => this.voyageNumber.sameValueAs(other.voyageNumber);
}

shared class MovementStep(arrivalLocation, departureTime, arrivalTime) {
    shared Location arrivalLocation;
    shared Date departureTime;
    shared Date arrivalTime;
}