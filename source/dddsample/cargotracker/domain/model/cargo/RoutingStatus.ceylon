import ceylon.language.meta {
	type
}
import ceylon.collection {

	HashMap
}
shared abstract class RoutingStatus(shared String name) 
	of not_routed | routed | misrouted {
	//shared String name => type(this).declaration.name;
}

shared object not_routed extends RoutingStatus("not_routed") {}
shared object routed extends RoutingStatus("routed") {}
shared object misrouted extends RoutingStatus("misrouted") {}


shared RoutingStatus?(String) getRoutingStatusByName
		= HashMap{*`RoutingStatus`.caseValues.map((ts) => ts.name->ts)}.get;

