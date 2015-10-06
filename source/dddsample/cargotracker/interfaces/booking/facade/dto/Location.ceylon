

// workaround to deactivate the automatic conversion from ceylon.language.String to java.lang.String for unLocode
// else it causes this JSF error "Validation Error: Value is not valid" with <p:selectOneMenu/>
shared abstract class AbstractLocation<CeylonString>(shared CeylonString unLocode, String simpleName) 
		given CeylonString satisfies String{
	shared String name => simpleName + " (" + unLocode + ")";
}

shared class Location(String unLocode, String simpleName) 
		extends AbstractLocation<String>(unLocode,simpleName){}

