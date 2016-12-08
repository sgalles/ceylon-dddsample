
shared abstract class RoutingStatus() 
		of not_routed | routed | misrouted {
}

shared object not_routed extends RoutingStatus() {}
shared object routed extends RoutingStatus() {}
shared object misrouted extends RoutingStatus() {}


