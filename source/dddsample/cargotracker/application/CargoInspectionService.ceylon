import dddsample.cargotracker.domain.model.cargo {
    TrackingId
}

shared interface CargoInspectionService {

    "Inspect cargo and send relevant notifications to interested parties, for
     example if a cargo has been misdirected, or unloaded at the final
     destination."
    shared formal void inspectCargo(TrackingId trackingId);

}