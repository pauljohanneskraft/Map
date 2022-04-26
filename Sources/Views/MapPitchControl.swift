//
//  MapPitchControl.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if os(macOS)

import SwiftUI
import MapKit

@available(macOS 11, *)
public struct MapPitchControl<Key: MapKey> {

    // MARK: Initialization

    public init(key: Key.Type) {}

}

@available(macOS 11, *)
extension MapPitchControl: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKPitchControl {
        let view = MKPitchControl(mapView: MapRegistry[Key.self])
        updateNSView(view, context: context)
        return view
    }

    public func updateNSView(_ pitchControl: MKPitchControl, context: Context) {
        pitchControl.mapView = MapRegistry[Key.self]
    }

}

#endif
