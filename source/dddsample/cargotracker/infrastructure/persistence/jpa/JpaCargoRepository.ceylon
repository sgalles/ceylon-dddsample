import ceylon.interop.java {
    javaString,
    CeylonList
}

import dddsample.cargotracker.domain.model.cargo {
    CargoRepository,
    Cargo,
    TrackingId,
    Itinerary
}

import java.util {
    UUID
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
class JpaCargoRepository(
    EntityManager entityManager
) satisfies CargoRepository{

    shared actual Cargo? find(TrackingId trackingId) {
        try {
            return entityManager.createNamedQuery("Cargo.findByTrackingId",`Cargo`)
                    .setParameter("trackingId", trackingId)
                    .singleResult;
        } catch (NoResultException e) {
            return null;
        }
    }

    shared actual void store(Cargo cargo, Itinerary? newItinerary) {
        if (exists newItinerary, exists oldItinerary = cargo.itinerary) {
            for (leg in oldItinerary.legsMaybeEmpty){
                entityManager.remove(leg);
            }
            cargo.assignToRoute(newItinerary);
        }
        entityManager.persist(cargo);
    }

    nextTrackingId()
            => let(random = javaString(UUID.randomUUID().string.uppercased))
            TrackingId(random.substring(0, random.indexOf("-"))); // TODO : Ceylonize

    findAll()
            => CeylonList(entityManager.createNamedQuery("Cargo.findAll", `Cargo`)
                    .resultList);

}