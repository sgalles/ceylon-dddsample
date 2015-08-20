import ceylon.interop.java {
	javaClass
}

import dddsample.cargotracker.domain.model.voyage {
	VoyageRepository,
	Voyage,
	VoyageNumber
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
class JpaVoyageRepository() satisfies VoyageRepository & Serializable{
	
	inject
	late EntityManager entityManager;
	
	shared actual Voyage? find(VoyageNumber voyageNumber) {

        try {
            return entityManager.createNamedQuery("Voyage.findByVoyageNumber", javaClass<Voyage>())
						        .setParameter("voyageNumber", voyageNumber).singleResult;
        } catch (NoResultException e) {
            return null;
        }

	}
	
	
}