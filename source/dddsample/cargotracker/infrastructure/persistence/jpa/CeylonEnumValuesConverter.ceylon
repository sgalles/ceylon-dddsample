import ceylon.language.meta.model {
    ClassOrInterface
}

import dddsample.cargotracker.domain.model.cargo {
    RoutingStatus,
    TransportStatus
}
import dddsample.cargotracker.domain.model.handling {
    HandlingEventType
}
import dddsample.cargotracker.infrastructure.ceylon {
    caseValues
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


shared class CeylonEnumValuesConverter<EnumValue>() 
        satisfies AttributeConverter<EnumValue, JString>
		given EnumValue satisfies Object {
	
	"Not a class or interface type."
	assert (is ClassOrInterface<EnumValue> enumType = `EnumValue`);
	
	"No elements found for enum values. Is the metamodel initialized?"
	assert (nonempty enums = caseValues(enumType));
	
	value nameByEnumValue
			= enums.tabulate((val) => JString(val.string));
	
	value enumValueByName
			= nameByEnumValue.inverse().mapItems((key, items) => items[0]);
	
	shared actual JString? convertToDatabaseColumn(EnumValue? x) {
	    if (exists x) {
	        assert (exists name = nameByEnumValue[x]);
	        return name;
	    }
	    else {
	        return null;
	    }
	}
	
	shared actual EnumValue? convertToEntityAttribute(JString? y) {
		if (exists y) {
			if (exists x = enumValueByName[y]) {
				return x;
			}
			else {
				throw IllegalStateException("Unable to convert string ``y`` into RoutingStatus");
			}
		}
		else {
			return null;
		}
	}
	
}

