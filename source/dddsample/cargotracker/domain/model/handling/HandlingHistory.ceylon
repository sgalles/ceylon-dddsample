import ceylon.collection {
	HashSet
}


shared class HandlingHistory {
	
	
	shared HandlingEvent[] allHandlingEvents;
	
	shared new ({HandlingEvent*} allHandlingEvents){
		this.allHandlingEvents = allHandlingEvents.sequence();
	}
	
	shared new empty extends HandlingHistory({}) {}
	
	shared HandlingEvent[] distinctEventsByCompletionTime 
			=> HashSet{*allHandlingEvents}
			.sort((he1, he2) => he1.completionTime.compareTo(he2.completionTime) <=> 0);
	
	shared HandlingEvent? mostRecentlyCompletedEvent 
			=> distinctEventsByCompletionTime.last;
	
	
	
}