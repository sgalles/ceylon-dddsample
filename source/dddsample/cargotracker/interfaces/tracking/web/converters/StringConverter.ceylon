import javax.faces.component {
	UIComponent
}
import javax.faces.context {
	FacesContext
}
import javax.faces.convert {
	Converter,
	facesConverter
}
import ceylon.language{
	CeylonString = String
}

facesConverter{\ivalue="ceylon-string";}
shared class StringConverter() satisfies Converter{
	getAsObject(FacesContext? facesContext, UIComponent? uIComponent, String ceylonString) 
			=> ceylonString;
	
	getAsString(FacesContext? facesContext, UIComponent? uIComponent, Object ceylonString) 
			=> ceylonString.string;
	
}