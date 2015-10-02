import java.io {
	Serializable
}

shared abstract class AbstractLocation<CeylonString>(shared CeylonString unLocode, String simpleName) 
		satisfies Serializable given CeylonString satisfies String{
	shared String name => simpleName + " (" + unLocode + ")";
}

shared class Location(String unLocode, String simpleName) 
		extends AbstractLocation<String>(unLocode,simpleName){}

