//
//  MapZoomControl.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if os(macOS)

import SwiftUI
import MapKit

@available(macOS 11, *)
public struct MapZoomControl {

    // MARK: Stored Properties

    private let key: AnyHashable

    // MARK: Initialization

    public init<Key: Hashable>(key: Key) {
        self.key = key
    }

}

// MARK: - UIViewRepresentable

@available(macOS 11, *)
extension MapZoomControl: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKZoomControl {
        let view = MKZoomControl(mapView: MapRegistry[key])
        updateNSView(view, context: context)
        return view
    }

    public func updateNSView(_ zoomControl: MKZoomControl, context: Context) {
        zoomControl.mapView = MapRegistry[key]
    }

}

#endif
