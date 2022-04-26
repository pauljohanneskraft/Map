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
public struct MapZoomControl<Key: MapKey> {

    // MARK: Initialization

    public init(key: Key.Type) {}

}

// MARK: - UIViewRepresentable

@available(macOS 11, *)
extension MapZoomControl: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKZoomControl {
        let view = MKZoomControl(mapView: MapRegistry[Key.self])
        updateNSView(view, context: context)
        return view
    }

    public func updateNSView(_ zoomControl: MKZoomControl, context: Context) {
        zoomControl.mapView = MapRegistry[Key.self]
    }

}

#endif
