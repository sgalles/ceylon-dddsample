


import dddsample.cargotracker.domain.infrastructure.persistence.jpa {
	TransportStatusConverter
}

import javax.persistence {
	embeddable,
	convert__FIELD
}


embeddable
shared class Delivery {
	
	convert__FIELD{converter = `TransportStatusConverter`;}
	shared variable TransportStatus transportStatus = claimed;
	
	shared new init(){
		
	}
	
	shared new () extends init(){
		
	}
	
	shared new empty extends init(){}	
	
}
