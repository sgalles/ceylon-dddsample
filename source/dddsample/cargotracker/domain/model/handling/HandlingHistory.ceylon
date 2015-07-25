import ceylon.collection {

	ArrayList
}
shared class HandlingHistory() {
	
	"""
    return A distinct list (no duplicate registrations) of handling events,
    ordered by completion time.
    """    
	shared List<HandlingEvent> distinctEventsByCompletionTime {
		/*List<HandlingEvent> ordered = new ArrayList<>(new HashSet<>(
			handlingEvents));
		Collections.sort(ordered, BY_COMPLETION_TIME_COMPARATOR);
		
		return Collections.unmodifiableList(ordered);*/
		return ArrayList{HandlingEvent(),HandlingEvent(),HandlingEvent()};
	}
	
}