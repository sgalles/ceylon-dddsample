
shared class RoutingStatus 
	of not_routed | routed | misrouted {

    shared actual String string;

    shared new not_routed {string="not_routed";}
    shared new routed {string="routed";}
    shared new misrouted {string="misrouted";}
}



