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
class JpaCargoRepository() satisfies CargoRepository{
	
	inject
	late EntityManager entityManager;
	
	shared actual Cargo? find(TrackingId trackingId) {

        try {
            value cargo = entityManager.createNamedQuery("Cargo.findByTrackingId",javaClass<Cargo>())
                    .setParameter("trackingId", trackingId)
                    .singleResult;
            return cargo;
        } catch (NoResultException e) {
            return null;
        }

	}
	
	shared actual void store(Cargo cargo) {
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