import dddsample.cargotracker.application.util {
	toJavaList
}
import java.util {
	JList=List,
	Collections
}
import java.io {

	Serializable
}
"""
   DTO for presenting and selecting an itinerary from a collection of
   candidates.
   """
shared class RouteCandidate satisfies Serializable{
	
	JList<Leg> _legs; 
	shared new({Leg*} legs){
		_legs = toJavaList(legs); 
	}
	
	shared JList<Leg> legs => Collections.unmodifiableList(_legs);
}