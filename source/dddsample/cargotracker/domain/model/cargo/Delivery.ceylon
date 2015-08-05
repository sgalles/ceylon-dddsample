


import dddsample.cargotracker.domain.infrastructure.persistence.jpa {
	TransportStatusConverter,
	RoutingStatusConverter
}

import javax.persistence {
	embeddable,
	convert=convert__FIELD,
	column=column__FIELD
}


embeddable
shared class Delivery {
	
	convert{converter = `TransportStatusConverter`;}
	column{name = "transport_status";}
	shared TransportStatus transportStatus = claimed;
	
	convert{converter = `RoutingStatusConverter`;}
	column{name = "routing_status";}
	shared RoutingStatus routingStatus = misrouted;
	
	shared new init(){
		
	}
	
	shared new () extends init(){
		
	}
	
	shared new empty extends init(){}	
	
}
