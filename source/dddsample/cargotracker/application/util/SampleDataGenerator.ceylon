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
import dddsample.cargotracker.domain.model.handling {
	HandlingEventFactory,
	receive,
	load,
	unload,
	HandlingEventRepository,
	customs,
	claim
}
import dddsample.cargotracker.domain.model.location {
	Location {
		...
	}
}
import dddsample.cargotracker.domain.model.voyage {
	Voyage {
		...
	}
}

import java.util {
	Date
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
	inject=inject__SETTER
}
import javax.persistence {
	EntityManager
}



singleton
startup
shared class SampleDataGenerator() {
	
	inject
	late EntityManager entityManager;
	
	inject
	late HandlingEventFactory handlingEventFactory;
	
	inject
	late HandlingEventRepository handlingEventRepository;

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
		
		if(true){
		
			Cargo abc123 = Cargo.init {
				trackingId = TrackingId.init("ABC123");
				routeSpecification = RouteSpecification.init { 
					origin = hongkong; 
					destination = helsinki; 
					arrivalDeadline = toDate("2014-03-15"); 
				};
			};
			
			abc123.assignToRoute(
				Itinerary.init{
					Leg.init(hongkong_to_new_york, 
						hongkong, newyork,
						toDate("2014-03-02"), toDate("2014-03-05")
					),
					Leg.init(new_york_to_dallas, 
						newyork, dallas,
						toDate("2014-03-06"), toDate("2014-03-08")
					),
					Leg.init(dallas_to_helsinki, 
						dallas, helsinki,
						toDate("2014-03-09"), toDate("2014-03-12")
					)
				}
			);
			
			entityManager.persist(abc123);
			
			{
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2014-03-01"), abc123.trackingId, 
					hongkong.unLocode, receive),
			
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2014-03-02"), abc123.trackingId, 
					hongkong.unLocode, [load, hongkong_to_new_york.voyageNumber]),
				
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2014-03-05"), abc123.trackingId, 
					newyork.unLocode, [unload, hongkong_to_new_york.voyageNumber])
				
			}.each(entityManager.persist);
	
			abc123.deriveDeliveryProgress{
				handlingHistory = handlingEventRepository.lookupHandlingHistoryOfCargo(abc123.trackingId);
			};
			entityManager.persist(abc123);
		
		}
		
		if(true){
			// Cargo JKL567
			Cargo jkl567 = Cargo.init {
				trackingId = TrackingId.init("JKL567");
				routeSpecification = RouteSpecification.init { 
					origin = hangzou; 
					destination = stockholm; 
					arrivalDeadline = toDate("2014-03-18"); 
				};
			};
			
			jkl567.assignToRoute(
				Itinerary.init{
					Leg.init(hongkong_to_new_york, 
						hangzou, newyork,
						toDate("2014-03-03"), toDate("2014-03-05")
					),
					Leg.init(new_york_to_dallas, 
						newyork, dallas,
						toDate("2014-03-06"), toDate("2014-03-08")
					),
					Leg.init(dallas_to_helsinki, 
						dallas, stockholm,
						toDate("2014-03-09"), toDate("2014-03-11")
					)
				}
			);
			
			entityManager.persist(jkl567);
			
			{
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2014-03-01"), jkl567.trackingId, 
					hangzou.unLocode, receive),
				
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2014-03-03"), jkl567.trackingId, 
					hangzou.unLocode, [load, hongkong_to_new_york.voyageNumber]),
				
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2014-03-05"), jkl567.trackingId, 
					newyork.unLocode, [unload, hongkong_to_new_york.voyageNumber]),
				
				handlingEventFactory.createHandlingEvent(
						Date(), toDate("2014-03-06"), jkl567.trackingId, 
						newyork.unLocode, [load, hongkong_to_new_york.voyageNumber])
				
			}.each(entityManager.persist);
			
			jkl567.deriveDeliveryProgress{
				handlingHistory = handlingEventRepository.lookupHandlingHistoryOfCargo(jkl567.trackingId);
			};
			entityManager.persist(jkl567);
			
		}

		if(true){
			// Cargo definition DEF789. This one will remain unrouted.
			Cargo def789 = Cargo.init {
				trackingId = TrackingId.init("DEF789");
				routeSpecification = RouteSpecification.init { 
					origin = hongkong; 
					destination = melbourne; 
					arrivalDeadline = toDate("2014-11-18"); 
				};
			};
			entityManager.persist(def789);
		}
		
		
		if(true){
			// Cargo definition MNO456. This one will be claimed properly.
			Cargo mno456 = Cargo.init {
				trackingId = TrackingId.init("MNO456");
				routeSpecification = RouteSpecification.init { 
					origin = newyork; 
					destination = dallas; 
					arrivalDeadline = toDate("2014-3-27"); 
				};
			};
			
			mno456.assignToRoute(
				Itinerary.init{
					Leg.init(new_york_to_dallas, 
						newyork, dallas,
						toDate("2013-10-24"), toDate("2013-10-25")
					)
				}
			);
			
			entityManager.persist(mno456);
			
			{
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2013-10-18"), mno456.trackingId, 
					newyork.unLocode, receive),
				
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2013-10-24"), mno456.trackingId, 
					newyork.unLocode, [load, new_york_to_dallas.voyageNumber]),
				
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2013-10-25"), mno456.trackingId, 
					dallas.unLocode, [unload, new_york_to_dallas.voyageNumber]),
				
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2013-10-26"), mno456.trackingId, 
					dallas.unLocode, customs),
				
				handlingEventFactory.createHandlingEvent(
					Date(), toDate("2013-10-27"), mno456.trackingId, 
					dallas.unLocode, claim)
				
			}.each(entityManager.persist);
			
			mno456.deriveDeliveryProgress{
				handlingHistory = handlingEventRepository.lookupHandlingHistoryOfCargo(mno456.trackingId);
			};
			entityManager.persist(mno456);
			
		}
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
		
		entityManager.persist(hongkong);
		entityManager.persist(melbourne);
		entityManager.persist(stockholm);
		entityManager.persist(helsinki);
		entityManager.persist(chicago);
		entityManager.persist(tokyo);
		entityManager.persist(hamburg);
		entityManager.persist(shanghai);
		entityManager.persist(rotterdam);
		entityManager.persist(gothenburg);
		entityManager.persist(hangzou);
		entityManager.persist(newyork);
		entityManager.persist(dallas);
		
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
		
		entityManager.persist(hongkong_to_new_york);
		entityManager.persist(new_york_to_dallas);
		entityManager.persist(dallas_to_helsinki);
		entityManager.persist(helsinki_to_hongkong);
		entityManager.persist(dallas_to_helsinki_alt);
		
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