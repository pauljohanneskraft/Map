//
//  MapCameraBoundary.swift
//  Map
//
//  Created by Paul Kraft on 04.05.22.
//

#if !os(watchOS)

import Foundation
import MapKit
import SwiftUI

private enum MapBoundaryKey: EnvironmentKey {

    static var defaultValue: MKMapView.CameraBoundary? { nil }

}

extension EnvironmentValues {

    var mapBoundary: MKMapView.CameraBoundary? {
        get { self[MapBoundaryKey.self] }
        set { self[MapBoundaryKey.self] = newValue }
    }

}

extension View {

    public func mapBoundary(_ boundary: MKMapView.CameraBoundary?) -> some View {
        environment(\.mapBoundary, boundary)
    }

}

#endif
