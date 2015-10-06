
"""
   DTO for presenting and selecting an itinerary from a collection of
   candidates.
   """
shared class RouteCandidate(shared {Leg+} legs){
	
	/*JList<Leg> _legs; 
	shared new({Leg*} legs){
		_legs = toJavaList(legs); 
	}
	
	shared JList<Leg> legs => Collections.unmodifiableList(_legs);*/
}