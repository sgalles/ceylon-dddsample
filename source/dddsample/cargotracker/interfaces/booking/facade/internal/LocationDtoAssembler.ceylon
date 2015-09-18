import dddsample.cargotracker.domain.model.location {
	LocationModel=Location
}
import dddsample.cargotracker.interfaces.booking.facade.dto {
	Location
}
object locationDtoAssembler {
	
	Location toDto(LocationModel location) 
			=> Location(location.unLocode.idString, location.name);
	
	List<Location> toDtoList(List<LocationModel> allLocations) 
			=> allLocations.collect(toDto).sort(byIncreasing(Location.name));
}