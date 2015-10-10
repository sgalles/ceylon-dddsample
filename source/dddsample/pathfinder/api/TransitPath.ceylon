import java.util {
	JList=List
}

import javax.xml.bind.annotation {
	xmlRootElement
}

shared class TransitPath(shared variable JList<TransitEdge> transitEdges) {}