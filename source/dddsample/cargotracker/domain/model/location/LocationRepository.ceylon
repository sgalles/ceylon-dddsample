shared interface LocationRepository {
	
	shared formal Location? find(UnLocode unLocode);
	
	shared formal List<Location> findAll();
}
