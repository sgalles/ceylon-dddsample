import dddsample.cargotracker.application.util {
	toJavaList
}
import dddsample.cargotracker.domain.model.cargo {
	Leg
}
import java.util {
	Date,
	JList=List,
	Collections
}
"""
   DTO for presenting and selecting an itinerary from a collection of
   candidates.
   """
shared class RouteCandidate {
	
	JList<Leg> _legs; 
	shared new({Leg*} legs){
		_legs = toJavaList(legs); 
	}
	
	shared JList<Leg> legs => Collections.unmodifiableList(_legs);
}