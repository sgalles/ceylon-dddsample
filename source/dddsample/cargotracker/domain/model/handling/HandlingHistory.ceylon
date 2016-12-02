import ceylon.collection {
	HashSet
}


import dddsample.cargotracker.infrastructure.ceylon {

	ceylonComparison
}

shared class HandlingHistory {
	
	
	shared HandlingEvent[] allHandlingEvents;
	
	shared new ({HandlingEvent*} allHandlingEvents){
		this.allHandlingEvents = allHandlingEvents.sequence();
	}
	
	shared new empty extends HandlingHistory({}) {}
	
	
    Comparison byCompletionTimeComparator(HandlingEvent he1, HandlingEvent he2) 
		=> ceylonComparison(he1.completionTime.compareTo(he2.completionTime));
	
    
	shared HandlingEvent[] distinctEventsByCompletionTime 
			=> HashSet{*allHandlingEvents}.sort(byCompletionTimeComparator);
	
	shared HandlingEvent? mostRecentlyCompletedEvent 
			=> distinctEventsByCompletionTime.last;
	
	
	
}