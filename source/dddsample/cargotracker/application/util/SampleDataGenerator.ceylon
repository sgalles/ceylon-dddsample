import ceylon.interop.java {
	javaClass,
	CeylonList
}

import dddsample.cargotracker.domain.model.cargo {
	Cargo,
	TrackingId
}
import dddsample.cargotracker.domain.model.location {
	Location
}

import javax.annotation {
	postConstruct
}
import javax.ejb {
	singleton,
	startup,
	transactionAttribute,
	TransactionAttributeType
}
import javax.persistence {
	persistenceContext__SETTER,
	EntityManager
}



singleton
startup
shared class SampleDataGenerator() {
	
	persistenceContext__SETTER
	late EntityManager entityManager;
	
	
	postConstruct
	transactionAttribute(TransactionAttributeType.\iREQUIRED)
	shared void loadSampleData(){
		// TODO use logs
		print("Loading sample data.");
		unLoadAll(); //  Fail-safe in case of application restart that does not trigger a JPA schema drop.
		loadSampleLocations();
		loadSampleCargos();
	}
	
	shared void unLoadAll() {
		
		print("Unloading all existing data.");
		// In order to remove handling events, must remove refrences in cargo.
		// Dropping cargo first won't work since handling events have references
		// to it.
		// TODO See if there is a better way to do this.
		List<Cargo> cargos =CeylonList(entityManager.createQuery("Select c from Cargo c",javaClass<Cargo>())
				.resultList);
		
		for(cargo in cargos){
			
		}
		entityManager.createQuery("Delete from Cargo").executeUpdate();
		
	}
	
	shared void loadSampleCargos() {
		
		print("Loading sample cargo data.");
		
		// Cargo ABC123
		TrackingId trackingId1 = TrackingId("ABC123");
		
		Cargo abc123 = Cargo(trackingId1);
		entityManager.persist(abc123);
		
	}
	
	shared void loadSampleLocations() {
		print("Loading sample locations.");
		
		entityManager.persist(Location.hongkong);
		entityManager.persist(Location.melbourne);
		entityManager.persist(Location.stockholm);
		entityManager.persist(Location.helsinki);
		entityManager.persist(Location.chicago);
		entityManager.persist(Location.tokyo);
		entityManager.persist(Location.hamburg);
		entityManager.persist(Location.shanghai);
		entityManager.persist(Location.rotterdam);
		entityManager.persist(Location.gothenburg);
		entityManager.persist(Location.hangzou);
		entityManager.persist(Location.newyork);
		entityManager.persist(Location.dallas);
		
		entityManager.flush();
		entityManager.clear();
		
		List<Location> locations =CeylonList(entityManager.createQuery("Select c from Location c",javaClass<Location>())
			.resultList);
		
		for(location in locations){
			print(location.unLocode.idString);
			
		}
	}
}