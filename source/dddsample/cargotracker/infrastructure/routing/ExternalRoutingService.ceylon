import dddsample.cargotracker.domain.model.cargo {
	Itinerary,
	RouteSpecification
}
import dddsample.cargotracker.domain.model.location {
	LocationRepository
}
import dddsample.cargotracker.domain.model.voyage {
	VoyageRepository
}
import dddsample.cargotracker.domain.service {
	RoutingService
}

import javax.annotation {
	resource=resource__FIELD
}
import javax.ejb {
	stateless
}
import javax.inject {
	inject=inject__FIELD
}
import javax.ws.rs.client {
	Client,
	ClientBuilder
}

"""
   Our end of the routing service. This is basically a data model translation
   layer between our domain model and the API put forward by the routing team,
   which operates in a different context from us.
   """
stateless
shared class ExternalRoutingService() satisfies RoutingService{
	
	resource{name = "graphTraversalUrl";}
	late String graphTraversalUrl;
	
	Client jaxrsClient = ClientBuilder.newClient();
	
	inject
	late LocationRepository locationRepository;
	
	inject
	late VoyageRepository voyageRepository;
	
	
	
	shared actual List<Itinerary> fetchRoutesForSpecification(RouteSpecification routeSpecification) => nothing;
	
}