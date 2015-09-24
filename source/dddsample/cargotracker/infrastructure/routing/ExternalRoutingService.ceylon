import dddsample.cargotracker.domain.service {

	RoutingService
}
import dddsample.cargotracker.domain.model.cargo {

	Itinerary,
	RouteSpecification
}
shared class ExternalRoutingService() satisfies RoutingService{
	shared actual List<Itinerary> fetchRoutesForSpecification(RouteSpecification routeSpecification) => nothing;
	
}