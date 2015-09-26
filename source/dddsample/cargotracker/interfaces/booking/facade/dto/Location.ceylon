import java.io {

	Serializable
}
import java.lang {
	JString=String
}
import ceylon.interop.java {

	javaString
}

shared class Location(String _unLocode, String simpleName) satisfies Serializable{
	shared JString unLocode = javaString(_unLocode);
	shared String name => simpleName + " (" + unLocode.string + ")";
}