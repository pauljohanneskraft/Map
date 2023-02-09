//
//  UserTrackingMode.swift
//  Map
//
//  Created by Paul Kraft on 09.02.23.
//

import MapKit

public enum UserTrackingMode {

    // MARK: Cases

    case none
    case follow

    @available(macOS, unavailable)
    case followWithHeading

    // MARK: Computed Properties

    @available(macOS 11, *)
    var actualValue: MKUserTrackingMode {
        switch self {
        case .none:
            return .none
        case .follow:
            return .follow
        #if !os(macOS)
        case .followWithHeading:
            return .followWithHeading
        #endif
        }
    }

}
