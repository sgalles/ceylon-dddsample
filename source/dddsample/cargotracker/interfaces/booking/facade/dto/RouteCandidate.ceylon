import ceylon.interop.java {
	JavaList
}

import java.util {
	JList=List
}

"""
   DTO for presenting and selecting an itinerary from a collection of
   candidates.
   """
shared class RouteCandidate{
	shared {Leg+} legsSequence;
	shared new({Leg+} legs){
		legsSequence = legs;
	}
	shared JList<Leg> legs => JavaList<Leg>(legsSequence.sequence());
	
	
	
}