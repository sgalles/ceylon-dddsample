import ceylon.interop.java {
	CeylonList
}

import dddsample.cargotracker.domain.model.location {
	LocationRepository,
	Location,
	UnLocode
}

import javax.enterprise.context {
	applicationScoped
}
import javax.inject {
	inject
}
import javax.persistence {
	EntityManager,
	NoResultException
}


applicationScoped
inject
class JpaLocationRepository(
	EntityManager entityManager
) satisfies LocationRepository{
	
	shared actual Location? find(UnLocode unLocode) {

        try {
            return entityManager.createNamedQuery("Location.findByUnLocode",`Location`)
                    	.setParameter("unLocode", unLocode)
                		.singleResult;
        } catch (NoResultException e) {
            return null;
        }

	}
	
	shared actual List<Location> findAll() 
			=> CeylonList(
					entityManager.createNamedQuery("Location.findAll", `Location`)
					.resultList
				);

}