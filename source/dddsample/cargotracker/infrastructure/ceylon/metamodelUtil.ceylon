import ceylon.language.meta.declaration {
	OpenType,
	OpenClassOrInterfaceType
}
import ceylon.language.meta.model {
	ClassOrInterface
}

shared Type[] caseValues<Type>() {
	value type =  `Type`;
	if(is ClassOrInterface<Type> type){
		if(nonempty caseValues = type.caseValues){
			return caseValues;
		}else{
			assert(nonempty caseTypes = caseTypes<Type>());
			return caseTypes.flatMap((caseType) => caseType.caseValues).sequence();
		}
	}else{
		return [];
	}
}

[ClassOrInterface<Type>*] caseTypes<Type>() 
		=> if(is ClassOrInterface<Type> type = `Type`) then type.declaration.caseTypes.collect((OpenType caseOpenType) {
	assert(is OpenClassOrInterfaceType caseOpenType);
	return caseOpenType.declaration.apply<Type>();
}) else nothing;