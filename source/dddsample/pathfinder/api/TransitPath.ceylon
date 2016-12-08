import java.util {
	JList=List
}

import javax.xml.bind.annotation {
	xmlTransient
}

shared class TransitPath(shared variable JList<TransitEdge> transitEdges) {
	
	xmlTransient
	shared [TransitEdge+] transitEdgesSeq {
		value transitEdgesSeq = [*transitEdges];
		assert(nonempty transitEdgesSeq); 
		return transitEdgesSeq;
	}
	
}