import ceylon.interop.java {
	CeylonCollection
}

import java.util {
	JList=List
}

import javax.xml.bind.annotation {
	xmlTransient
}

shared class TransitPath(shared variable JList<TransitEdge> transitEdges) {
	
	xmlTransient
	shared [TransitEdge+] transitEdgesSeq {
		value transitEdgesSeq = CeylonCollection(transitEdges).sequence();
		assert(nonempty transitEdgesSeq); 
		return transitEdgesSeq;
	}
	
}