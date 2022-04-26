//
//  MapUserTrackingMode.swift
//  Map
//
//  Created by Paul Kraft on 25.04.22.
//

import MapKit

@available(macOS 11, watchOS 6.1, *)
public enum MapUserTrackingMode: Hashable {

    case none
    case follow

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case followWithHeading

}

#if os(watchOS)

import WatchKit

@available(watchOS 6.1, *)
extension MapUserTrackingMode {

    var actualValue: WKInterfaceMap.UserTrackingMode {
        switch self {
        case .follow:
            return .follow
        case .none:
            return .none
        }
    }

}

#else

@available(macOS 11, *)
extension MapUserTrackingMode {

    var actualValue: MKUserTrackingMode {
        switch self {
        case .followWithHeading:
            #if os(macOS) || os(tvOS)
            return .follow
            #else
            return .followWithHeading
            #endif
        case .follow:
            return .follow
        case .none:
            return .none
        }
    }

}

#endif
