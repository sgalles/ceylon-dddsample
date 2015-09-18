import java.io {

	Serializable
}
shared class Location(unLocode, String simpleName) satisfies Serializable{
	shared String unLocode;
	shared String name => simpleName + " (" + unLocode + ")";
}