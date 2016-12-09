import dddsample.cargotracker.domain.model.cargo {
    Itinerary,
    RouteSpecification
}
shared interface RoutingService {

    /**
        * @param routeSpecification route specification
        * @return A list of itineraries that satisfy the specification. May be an
        * empty list if no route is found.
        */
    shared formal List<Itinerary> fetchRoutesForSpecification(RouteSpecification routeSpecification);
}