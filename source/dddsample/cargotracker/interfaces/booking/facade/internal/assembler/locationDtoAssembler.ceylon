import dddsample.cargotracker.domain.model.location {
    LocationModel=Location
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
    Location
}

shared object locationDtoAssembler {

    shared Location toDto(LocationModel location)
            => Location(location.unLocode.idString, location.name);

    shared List<Location> toDtoList(List<LocationModel> allLocations)
            => allLocations.collect(toDto).sort(byIncreasing(Location.name));
}