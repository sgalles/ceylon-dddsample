
shared class Location(String _unLocode, String simpleName) {
	
	// workaround to deactivate the automatic conversion from ceylon.language.String to java.lang.String for unLocode
	// else it causes this JSF error "Validation Error: Value is not valid" with <p:selectOneMenu/>
	// we must keep String?
	shared String? unLocode = _unLocode;
	
	shared String name => "``simpleName`` (``_unLocode``)";
}
		

