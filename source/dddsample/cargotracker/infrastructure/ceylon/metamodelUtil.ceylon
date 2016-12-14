import ceylon.language.meta.declaration {
    OpenClassOrInterfaceType
}
import ceylon.language.meta.model {
    ClassOrInterface
}

import java.lang {
    IllegalStateException
}

shared Type[] caseValues<Type>(ClassOrInterface<Type> model) {
    if (nonempty caseValues = model.caseValues) {
        return caseValues;
    }
    else {
        assert (nonempty caseTypes = caseTypes(model));
        return caseTypes.flatMap(ClassOrInterface.caseValues).sequence();
    }
}



[ClassOrInterface<Type>*] caseTypes<Type>(ClassOrInterface<Type> model) 
        => model.declaration.caseTypes.collect((caseOpenType) {
           assert (is OpenClassOrInterfaceType caseOpenType);
           return caseOpenType.declaration.apply<Type>();
        });
        
        
shared class CeylonEnumMetadata<EnumValue>() 
        given EnumValue satisfies Object {
    
    "Not a class or interface type."
    assert (is ClassOrInterface<EnumValue> enumType = `EnumValue`);
    
    "No elements found for enum values. Is the metamodel initialized?"
    assert (nonempty enums = caseValues(enumType));
    
    value nameByEnumValue
            = enums.tabulate((val) => val.string);
    
    value enumValueByName
            = nameByEnumValue.inverse().mapItems((key, items) => items[0]);
    
    shared String getName(EnumValue enum){
        assert (exists name = nameByEnumValue[enum]);
        return name;
    }
    
    shared EnumValue getValue(String name){
        if (exists enum = enumValueByName[name]) {
            return enum;
        }
        else {
            throw IllegalStateException("Unable to convert string ``name`` into ``enumType.declaration.name``");
        }
    }
    
}
       

