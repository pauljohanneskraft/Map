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

private struct MapBoundaryKey: EnvironmentKey {

    static var defaultValue: MKMapView.CameraBoundary?

}

extension EnvironmentValues {

    var mapBoundary: MKMapView.CameraBoundary? {
        get { self[MapBoundaryKey.self] }
        set { self[MapBoundaryKey.self] = newValue }
    }

}

extension View {

    public func mapBoundary(region: MKCoordinateRegion?) -> some View {
        environment(\.mapBoundary, region.flatMap { .init(coordinateRegion: $0) })
    }

    public func mapBoundary(mapRect: MKMapRect?) -> some View {
        environment(\.mapBoundary, mapRect.flatMap { .init(mapRect: $0) })
    }

}

#endif
