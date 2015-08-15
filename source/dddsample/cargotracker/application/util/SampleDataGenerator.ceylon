import ceylon.interop.java {
	javaClass,
	CeylonList
}

import dddsample.cargotracker.domain.model.cargo {
	Cargo,
	TrackingId,
	RouteSpecification,
	Itinerary,
	Leg
}
import dddsample.cargotracker.domain.model.location {
	Location
}
import dddsample.cargotracker.domain.model.voyage {
	Voyage
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
import javax.inject {
	inject = inject__SETTER
}
import javax.persistence {
	EntityManager
}



singleton
startup
shared class SampleDataGenerator() {
	
	inject
	late EntityManager entityManager;
	
	

	postConstruct
	transactionAttribute(TransactionAttributeType.\iREQUIRED)
	shared void loadSampleData(){
		// TODO use logs
		print("Loading sample data.");
		unLoadAll(); //  Fail-safe in case of application restart that does not trigger a JPA schema drop.
		loadSampleLocations();
		loadSampleVoyages();
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
		Cargo abc123 = Cargo.init {
			trackingId = TrackingId.init("ABC123");
			routeSpecification = RouteSpecification.init { 
				origin = Location.hongkong; 
				destination = Location.helsinki; 
				arrivalDeadline = toDate("2014-03-15"); 
			};
		};
		
		abc123.assignToRoute(
			Itinerary.init{
				Leg.init(Voyage.hongkong_to_new_york, 
					Location.hongkong, Location.newyork,
					toDate("2014-03-02"), toDate("2014-03-05")
				),
				Leg.init(Voyage.new_york_to_dallas, 
					Location.newyork, Location.dallas,
					toDate("2014-03-06"), toDate("2014-03-08")
				),
				Leg.init(Voyage.dallas_to_helsinki, 
					Location.dallas, Location.helsinki,
					toDate("2014-03-09"), toDate("2014-03-12")
				)
			}
		);
		
		entityManager.persist(abc123);
		
		/*entityManager.flush();
		entityManager.clear();*/
		
		List<Cargo> cargos =CeylonList(entityManager.createQuery("Select c from Cargo c",javaClass<Cargo>())
			.resultList);
		
		for(c  in cargos){
			print(c.trackingId);
			
		}
		
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
		
		//entityManager.flush();
		//entityManager.clear();
		
		List<Location> locations =CeylonList(entityManager.createQuery("Select c from Location c",javaClass<Location>())
			.resultList);
		
		for(location in locations){
			print(location.unLocode.idString);
			
		}
	}
	
	shared void loadSampleVoyages() {
		print("Loading sample voyages.");
		
		entityManager.persist(Voyage.hongkong_to_new_york);
		entityManager.persist(Voyage.new_york_to_dallas);
		entityManager.persist(Voyage.dallas_to_helsinki);
		entityManager.persist(Voyage.helsinki_to_hongkong);
		entityManager.persist(Voyage.dallas_to_helsinki_alt);
		
		//entityManager.flush();
		//entityManager.clear();
		
		List<Voyage> voyages =CeylonList(entityManager.createQuery("Select c from Voyage c",javaClass<Voyage>())
			.resultList);
		
		for(v in voyages){
			print(v.schedule);
			
		}
		//HONGKONG_TO_NEW_YORK
		/*entityManager.persist(Voyage.);
		entityManager.persist(SampleVoyages.NEW_YORK_TO_DALLAS);
		entityManager.persist(SampleVoyages.DALLAS_TO_HELSINKI);
		entityManager.persist(SampleVoyages.HELSINKI_TO_HONGKONG);
		entityManager.persist(SampleVoyages.DALLAS_TO_HELSINKI_ALT);*/
	}
}