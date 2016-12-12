import dddsample.cargotracker.domain.model.cargo {
    HandlingActivity
}
import dddsample.cargotracker.domain.model.handling {
    HandlingHistory,
    HandlingEvent,
    HandlingEventTypeRequiredVoyage {
        ...
    },
    HandlingEventTypeProhibitedVoyage {
        ...
    }
}
import dddsample.cargotracker.domain.model.location {
    Location
}
import dddsample.cargotracker.domain.model.voyage {
    Voyage
}
import dddsample.cargotracker.infrastructure.ceylon {
    copyDate
}
import dddsample.cargotracker.infrastructure.persistence.jpa {
    RoutingStatusConverter,
    TransportStatusConverter
}

import java.util {
    Date
}

import javax.persistence {
    embeddable,
    convert,
    column,
    manyToOne,
    joinColumn,
    embedded,
    TemporalType,
    temporal
}


embeddable
shared class Delivery {

    convert{converter = `class TransportStatusConverter`;}
    column{name = "transport_status";}
    shared TransportStatus transportStatus;

    manyToOne
    joinColumn{name = "last_known_location_id";}
    variable Location? _lastKnownLocation;

    manyToOne
    joinColumn{name = "current_voyage_id";}
    variable Voyage? _currentVoyage;

    temporal(TemporalType.date)
    Date? _eta;

    shared Boolean misdirected;

    embedded
    shared HandlingActivity? nextExpectedActivity;

    column{name = "unloaded_at_dest";}
    shared variable Boolean unloadedAtDestination;

    convert{converter = `class RoutingStatusConverter`;}
    column{name = "routing_status";}
    shared RoutingStatus routingStatus;

    manyToOne
    joinColumn{name = "last_event_id";}
    variable HandlingEvent? lastEvent;

    RoutingStatus calculateRoutingStatus(Itinerary? itinerary,
        RouteSpecification routeSpecification)
            => if (exists itinerary)
            then if (routeSpecification.isSatisfiedBy(itinerary))
                 then RoutingStatus.routed
                 else RoutingStatus.misrouted
            else RoutingStatus.not_routed;

    TransportStatus calculateTransportStatus(HandlingEvent? lastEvent) {
        if (exists lastEvent) {
            return switch(lastEvent.type)
                case (load) TransportStatus.onboard_carrier
                case (unload | receive | customs) TransportStatus.in_port
                case (claim) TransportStatus.claimed;
        }
        else {
            return TransportStatus.not_received;
        }
    }

    Boolean _onTrack(RoutingStatus routingStatus, Boolean misdirected)
            => routingStatus == RoutingStatus.routed && !misdirected;

    Date? calculateEta(Itinerary? itinerary, RoutingStatus routingStatus, Boolean misdirected)
            => if (_onTrack(routingStatus, misdirected))
            then itinerary?.finalArrivalDate()
            else null;

    HandlingActivity? calculateNextExpectedActivity(
        HandlingEvent? lastEvent,
        RouteSpecification routeSpecification,
        Itinerary? itinerary,
        RoutingStatus routingStatus,
        Boolean misdirected
    ) {

        if (!_onTrack(routingStatus, misdirected)) {
            return null;
        }

        assert(exists itinerary); // TODO : this because _ontrack means there's an itinerary...try to improve to remove assert

        if (!_onTrack(routingStatus, misdirected)) {
            return null;
        }
        else {
            if (exists lastEvent) {
                value legs = itinerary.legs;
                switch (lastEvent.type)
                case (load) {
                    value leg = legs.find((leg)
                        => leg.loadLocation.sameIdentityAs(lastEvent.location));
                    return if(exists leg)
                        then HandlingActivity {
                            typeAndVoyage = [unload, leg.voyage];
                            location = leg.unloadLocation;
                        }
                        else null;
                }
                case (unload) {
                    value pairedLegs = legs.paired.sequence().withTrailing([legs.last,null]);
                    value searchedPairedLeg = pairedLegs.find((pairedLeg)
                        => pairedLeg[0].unloadLocation.sameIdentityAs(lastEvent.location));
                    return
                        if (exists [leg, nextLeg] = searchedPairedLeg)
                        then if (exists nextLeg)
                            then HandlingActivity {
                                typeAndVoyage = [load, nextLeg.voyage];
                                location = nextLeg.loadLocation;
                            }
                            else HandlingActivity {
                                typeAndVoyage = claim;
                                location = leg.unloadLocation;
                            }
                        else null;
                }
                case (receive) {
                    value firstLeg = legs.first;
                    return HandlingActivity {
                        typeAndVoyage = [load, firstLeg.voyage];
                        location = firstLeg.loadLocation;
                    };
                }
                case (claim) {
                    return null;
                }
                case (customs) {
                    return null;
                }
            }
            else {
                return HandlingActivity {
                    typeAndVoyage = receive;
                    location = routeSpecification.origin;
                };
            }
        }
    }

    Boolean calculateUnloadedAtDestination(HandlingEvent? lastEvent,
        RouteSpecification routeSpecification)
            => if (exists lastEvent)
            then unload == lastEvent.type
              && routeSpecification.destination.sameIdentityAs(lastEvent.location)
            else false;

    shared new (HandlingEvent? lastEvent, Itinerary? itinerary,
        RouteSpecification routeSpecification) {

        Boolean calculateMisdirectionStatus()
                => if(exists lastEvent,exists itinerary)
                then !itinerary.isExpected(lastEvent)
                else false;

        this.lastEvent = lastEvent;
        this.routingStatus = calculateRoutingStatus {
            itinerary = itinerary;
            routeSpecification = routeSpecification;
        };
        this.transportStatus = calculateTransportStatus(lastEvent);
        this._lastKnownLocation = lastEvent?.location;
        this._currentVoyage
                = if (transportStatus == TransportStatus.onboard_carrier,
                      exists lastEvent)
                then lastEvent.voyage
                else null;
        this.misdirected = calculateMisdirectionStatus();
        this._eta = calculateEta {
            itinerary = itinerary;
            routingStatus = routingStatus;
            misdirected = misdirected;
        };
        this.nextExpectedActivity = calculateNextExpectedActivity {
            lastEvent = lastEvent;
            routeSpecification = routeSpecification;
            itinerary = itinerary;
            routingStatus = routingStatus;
            misdirected = misdirected;
        };
        this.unloadedAtDestination = calculateUnloadedAtDestination {
            lastEvent = lastEvent;
            routeSpecification = routeSpecification;
        };
    }

    shared new derivedFrom(
        RouteSpecification routeSpecification,
        Itinerary? itinerary,
        HandlingHistory handlingHistory
    ) extends Delivery(handlingHistory.mostRecentlyCompletedEvent,
                        itinerary, routeSpecification) {}

    shared Boolean onTrack => _onTrack(routingStatus,misdirected);

    shared Location lastKnownLocation => _lastKnownLocation else Location.unknown;
    assign lastKnownLocation => _lastKnownLocation = lastKnownLocation;

    shared Voyage? currentVoyage => _currentVoyage;
    assign currentVoyage => _currentVoyage = currentVoyage;

    shared Date? estimatedTimeOfArrival => if (exists _eta) then copyDate(_eta) else null;

    shared Delivery updateOnRouting(RouteSpecification routeSpecification, Itinerary? itinerary)
            => Delivery(this.lastEvent, itinerary, routeSpecification);

}
