shared class EventLineParseException(line, String? description=null, Throwable? cause=null) 
		extends Exception(description, cause){
	shared String line;
}