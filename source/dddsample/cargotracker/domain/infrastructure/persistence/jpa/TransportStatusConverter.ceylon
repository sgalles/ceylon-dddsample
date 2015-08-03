import ceylon.interop.java {
	javaString,
	javaClass
}

import dddsample.cargotracker.domain.model.cargo {
	TransportStatus,
	getTransportStatusByName
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
shared class TransportStatusConverter() satisfies AttributeConverter<TransportStatus, JString> {
	
	shared actual JString convertToDatabaseColumn(TransportStatus x) => javaString(x.name);
	
	shared actual TransportStatus convertToEntityAttribute(JString y) {
		if(exists x = getTransportStatusByName(y.string)){
			return x;
		}else{
			throw IllegalStateException("Unable to convert string ``y`` into TransportStatus");
		}
		
	}
	
}

