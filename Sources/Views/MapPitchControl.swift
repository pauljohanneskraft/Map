//
//  MapPitchControl.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if os(macOS) || targetEnvironment(macCatalyst)

import SwiftUI
import MapKit

@available(macCatalyst 14, macOS 11, *)
public struct MapPitchControl {

    // MARK: Stored Properties

    private let key: AnyHashable

    // MARK: Initialization

    public init<Key: Hashable>(key: Key) {
        self.key = key
    }

}

#endif

// MARK: - UIViewRepresentable

#if targetEnvironment(macCatalyst)

@available(macCatalyst 14, *)
extension MapPitchControl: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKPitchControl {
        let view = MKPitchControl(mapView: MapRegistry[key])
        updateUIView(view, context: context)
        return view
    }

    public func updateUIView(_ pitchControl: MKPitchControl, context: Context) {
        if let mapView = MapRegistry[key], mapView != pitchControl.mapView {
            pitchControl.mapView = mapView
        }
    }

}

#endif

// MARK: - NSViewRepresentable

#if os(macOS)

@available(macOS 11, *)
extension MapPitchControl: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKPitchControl {
        let view = MKPitchControl(mapView: MapRegistry[key])
        updateNSView(view, context: context)
        return view
    }

    public func updateNSView(_ pitchControl: MKPitchControl, context: Context) {
        if let mapView = MapRegistry[key], mapView != pitchControl.mapView {
            pitchControl.mapView = mapView
        }
    }

}

#endif
