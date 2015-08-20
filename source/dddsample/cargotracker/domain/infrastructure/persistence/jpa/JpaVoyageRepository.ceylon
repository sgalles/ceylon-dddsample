import ceylon.interop.java {
	javaClass,
	CeylonList
}

import dddsample.cargotracker.domain.model.location {
	LocationRepository,
	Location,
	UnLocode
}

import java.io {
	Serializable
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
class JpaLocationRepository() satisfies LocationRepository & Serializable{
	
	inject
	late EntityManager entityManager;
	
	shared actual Location? find(UnLocode unLocode) {

        try {
            return entityManager.createNamedQuery("Location.findByUnLocode",javaClass<Location>())
                    	.setParameter("unLocode", unLocode)
                		.singleResult;
        } catch (NoResultException e) {
            return null;
        }

	}
	
	shared actual List<Location> findAll() 
			=> CeylonList(
					entityManager.createNamedQuery("Location.findAll", javaClass<Location>())
					.resultList
				);

}