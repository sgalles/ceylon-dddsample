import ceylon.interop.java {
	javaClass,
	javaString,
	CeylonList
}

import dddsample.cargotracker.domain.model.cargo {
	CargoRepository,
	Cargo,
	TrackingId
}

import java.io {
	Serializable
}
import java.util {
	UUID
}

import javax.enterprise.context {
	applicationScoped
}
import javax.inject {
	inject=inject__FIELD
}
import javax.persistence {
	EntityManager,
	NoResultException
}


applicationScoped
class JpaCargoRepository() satisfies CargoRepository & Serializable{
	
	inject
	late EntityManager entityManager;
	
	shared actual Cargo? find(TrackingId trackingId) {

        try {
            return entityManager.createNamedQuery("Cargo.findByTrackingId",javaClass<Cargo>())
                    .setParameter("trackingId", trackingId)
                    .singleResult;
        } catch (NoResultException e) {
            return null;
        }

	}
	
	shared actual void store(Cargo cargo) {
		// TODO See why cascade is not working correctly for legs.
		for(leg in cargo.itinerary.legs){
			entityManager.persist(leg);
		}
		entityManager.persist(cargo);
	}
	
	shared actual TrackingId nextTrackingId() 
			=> let(random = javaString(UUID.randomUUID().string.uppercased))
				TrackingId.init(random.substring(0, random.indexOf("-"))); // TODO : Ceylonize
	
	shared actual List<Cargo> findAll() 
			=> CeylonList(
					entityManager.createNamedQuery("Cargo.findAll", javaClass<Cargo>())
					.resultList
				);
	

	

	
}