import ceylon.interop.java {
	CeylonCollection
}

import dddsample.cargotracker.domain.model.cargo {
	Itinerary,
	RouteSpecification,
	Leg
}
import dddsample.cargotracker.domain.model.location {
	LocationRepository,
	UnLocode
}
import dddsample.cargotracker.domain.model.voyage {
	VoyageRepository,
	VoyageNumber
}
import dddsample.cargotracker.domain.service {
	RoutingService
}
import dddsample.pathfinder.api {
	TransitEdge,
	TransitPath,
	TransitPaths
}

import javax.annotation {
	resource=resource__FIELD,
	postConstruct
}
import javax.ejb {
	stateless
}
import javax.inject {
	inject
}
import javax.ws.rs.client {
	Client,
	ClientBuilder,
	WebTarget
}
import javax.ws.rs.core {
	MediaType,
	GenericType
}


"""
   Our end of the routing service. This is basically a data model translation
   layer between our domain model and the API put forward by the routing team,
   which operates in a different context from us.
   """
stateless
inject
shared class ExternalRoutingService(
	LocationRepository locationRepository,
	VoyageRepository voyageRepository
) satisfies RoutingService{
	
	resource{name = "graphTraversalUrl";}
	late String graphTraversalUrl;
	
	late Client jaxrsClient;
	late WebTarget graphTraversalResource;
	
	postConstruct
	shared void init(){
		jaxrsClient = ClientBuilder.newClient();
		graphTraversalResource = jaxrsClient.target(graphTraversalUrl);
	}
	
	shared actual List<Itinerary> fetchRoutesForSpecification(RouteSpecification routeSpecification) {
		// The RouteSpecification is picked apart and adapted to the external API.
		String origin = routeSpecification.origin.unLocode.idString;
		String destination = routeSpecification.destination.unLocode.idString;
		
		TransitPaths transitPaths = graphTraversalResource
				.queryParam("origin", origin)
				.queryParam("destination", destination)
				.request(MediaType.\iAPPLICATION_JSON_TYPE)
				.get(object extends GenericType<TransitPaths>() {});
		
		Boolean routeSpecificationSatisfiesBy(TransitPath transitPath){
			Itinerary itinerary = toItinerary(transitPath);
			// Use the specification to safe-guard against invalid itineraries
			if (routeSpecification.isSatisfiedBy(itinerary)) {
				return true;
			} else {
				print("Received itinerary that did not satisfy the route specification"); // TODO : use log level FINE
				return false;
			}
		}

		List<Itinerary> itineraries = CeylonCollection(transitPaths.transitPath)
										.filter(routeSpecificationSatisfiesBy)
										.collect(toItinerary);
		
		return itineraries;
	}
	
	Itinerary toItinerary(TransitPath transitPath) => Itinerary(transitPath.transitEdgesSeq.map(toLeg));
	
	Leg toLeg(TransitEdge edge) => Leg(
                voyageRepository.find(VoyageNumber(edge.voyageNumber)) else nothing,
                locationRepository.find(UnLocode(edge.fromUnLocode)) else nothing,
                locationRepository.find(UnLocode(edge.toUnLocode)) else nothing,
                edge.fromDate, edge.toDate);
	
}