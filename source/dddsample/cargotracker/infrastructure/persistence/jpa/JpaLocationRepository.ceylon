import dddsample.cargotracker.domain.model.voyage {
	VoyageRepository,
	Voyage,
	VoyageNumber
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
class JpaVoyageRepository(
	EntityManager entityManager
) satisfies VoyageRepository {
	
	shared actual Voyage? find(VoyageNumber voyageNumber) {

        try {
            return entityManager.createNamedQuery("Voyage.findByVoyageNumber", `Voyage`)
						        .setParameter("voyageNumber", voyageNumber).singleResult;
        } catch (NoResultException e) {
            return null;
        }

	}
	
	
}