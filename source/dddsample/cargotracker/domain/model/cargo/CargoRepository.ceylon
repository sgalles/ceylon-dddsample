shared interface CargoRepository {

    shared formal Cargo? find(TrackingId trackingId);

    shared formal List<Cargo> findAll();

    shared formal void store(Cargo cargo, Itinerary? newItinerary = null);

    shared formal TrackingId nextTrackingId();

}