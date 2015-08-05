import ceylon.interop.java {
	javaString,
	javaClass
}

import dddsample.cargotracker.domain.model.cargo {
	RoutingStatus,
	getRoutingStatusByName
}

import java.lang {
	IllegalStateException,
	JString=String,
	Class
}

import javax.persistence {
	AttributeConverter,
	converter
}

converter //{autoApply = true;}
shared class RoutingStatusConverter() satisfies AttributeConverter<RoutingStatus, JString> {
	
	shared actual JString convertToDatabaseColumn(RoutingStatus x) => javaString(x.name);
	
	shared actual RoutingStatus convertToEntityAttribute(JString y) {
		if(exists x = getRoutingStatusByName(y.string)){
			return x;
		}else{
			throw IllegalStateException("Unable to convert string ``y`` into RoutingStatus");
		}
		
	}
	
}

