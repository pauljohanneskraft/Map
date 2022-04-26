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
public struct MapPitchControl {

    // MARK: Stored Properties

    private let key: AnyHashable

    // MARK: Initialization

    public init<Key: Hashable>(key: Key) {
        self.key = key
    }

}

@available(macOS 11, *)
extension MapPitchControl: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKPitchControl {
        let view = MKPitchControl(mapView: MapRegistry[key])
        updateNSView(view, context: context)
        return view
    }

    public func updateNSView(_ pitchControl: MKPitchControl, context: Context) {
        pitchControl.mapView = MapRegistry[key]
    }

}

#endif
