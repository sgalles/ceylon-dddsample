import dddsample.cargotracker.domain.model.cargo {
    RoutingStatus,
    TransportStatus
}
import dddsample.cargotracker.domain.model.handling {
    HandlingEventType
}
import dddsample.cargotracker.infrastructure.ceylon {
    CeylonEnumMetadata
}

import java.lang {
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

    CeylonEnumMetadata<EnumValue> enums = CeylonEnumMetadata<EnumValue>();

    shared actual JString? convertToDatabaseColumn(EnumValue? x) 
        => if(exists x) then JString(enums.getName(x)) else null;
       

    shared actual EnumValue? convertToEntityAttribute(JString? y)
        => if(exists y) then enums.getValue(y.string) else null;
       
}

