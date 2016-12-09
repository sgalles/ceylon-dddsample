import ceylon.language.meta.declaration {
    OpenClassOrInterfaceType
}
import ceylon.language.meta.model {
    ClassOrInterface
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

// TODO use same transformation code both for this and JPA Converters.
shared Type? caseValueByName<Type>(ClassOrInterface<Type> model, String name)
        => caseValues(model).find((val) => val.string.equalsIgnoringCase(name));

[ClassOrInterface<Type>*] caseTypes<Type>(ClassOrInterface<Type> model) 
        => model.declaration.caseTypes.collect((caseOpenType) {
           assert (is OpenClassOrInterfaceType caseOpenType);
           return caseOpenType.declaration.apply<Type>();
        });