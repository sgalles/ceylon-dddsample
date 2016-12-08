import java.util {
    JList=List
}

import javax.xml.bind.annotation {
    xmlTransient
}

shared class TransitPath(transitEdges) {

    shared JList<TransitEdge> transitEdges;
	
	xmlTransient
	shared [TransitEdge+] transitEdgesSeq {
		assert (nonempty transitEdgesSeq = [*transitEdges]);
		return transitEdgesSeq;
	}
	
}