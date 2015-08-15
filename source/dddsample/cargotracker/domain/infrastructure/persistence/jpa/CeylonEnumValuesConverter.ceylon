import ceylon.collection {
	HashMap
}
import ceylon.interop.java {
	javaString
}
import ceylon.language.meta {
	type
}

import dddsample.cargotracker.application.util {
	caseValues
}
import dddsample.cargotracker.domain.model.cargo {
	RoutingStatus,
	TransportStatus
}
import dddsample.cargotracker.domain.model.handling {
	HandlingEventType
}

import java.lang {
	IllegalStateException,
	JString=String
}

import javax.persistence {
	AttributeConverter,
	converter
}

converter //{autoApply = true;}
shared class TransportStatusConverter() 
		extends CeylonEnumValuesConverter<TransportStatus>() 
		satisfies AttributeConverter<TransportStatus, JString> {}

converter //{autoApply = true;}
shared class RoutingStatusConverter() 
		extends CeylonEnumValuesConverter<RoutingStatus>() 
		satisfies AttributeConverter<RoutingStatus, JString> {}

converter //{autoApply = true;}
shared class HandlingEventTypeConverter() 
		extends CeylonEnumValuesConverter<HandlingEventType>() 
		satisfies AttributeConverter<HandlingEventType, JString> {}


shared class CeylonEnumValuesConverter<EnumValue>() satisfies AttributeConverter<EnumValue, JString> 
		given EnumValue satisfies Object{
	
	value enums = caseValues<EnumValue>();
	
	EnumValue?(String) getEnumValueByName
			= HashMap{*enums.map((ts) => type(ts).declaration.name->ts)}.get;
	
	String?(EnumValue) getNameByEnumValue
			= HashMap{*enums.map((ts) => ts->type(ts).declaration.name)}.get;
	
	shared actual JString convertToDatabaseColumn(EnumValue x) => javaString(getNameByEnumValue(x) else nothing);
	
	shared actual EnumValue convertToEntityAttribute(JString y) {
		if(exists x = getEnumValueByName(y.string)){
			return x;
		}else{
			throw IllegalStateException("Unable to convert string ``y`` into RoutingStatus");
		}
		
	}
	
}

