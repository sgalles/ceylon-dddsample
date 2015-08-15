import ceylon.language.meta.model {
	ClassOrInterface
}
shared Type[] caseValues<Type>() 
		=> let(type = `Type`)if (is ClassOrInterface<Type> type) then type.caseValues else [];