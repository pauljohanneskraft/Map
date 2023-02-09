//
//  MapZoomControl.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if os(macOS) || targetEnvironment(macCatalyst)

import SwiftUI
import MapKit

@available(macCatalyst 14, macOS 11, *)
public struct MapZoomControl {

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
extension MapZoomControl: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKZoomControl {
        let view = MKZoomControl(mapView: MapRegistry[key])
        updateUIView(view, context: context)
        return view
    }

    public func updateUIView(_ zoomControl: MKZoomControl, context: Context) {
        if let mapView = MapRegistry[key], mapView != zoomControl.mapView {
            zoomControl.mapView = mapView
        }
    }

}


#endif


// MARK: - NSViewRepresentable

#if os(macOS)

@available(macOS 11, *)
extension MapZoomControl: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKZoomControl {
        let view = MKZoomControl(mapView: MapRegistry[key])
        updateNSView(view, context: context)
        return view
    }

    public func updateNSView(_ zoomControl: MKZoomControl, context: Context) {
        if let mapView = MapRegistry[key], mapView != zoomControl.mapView {
            zoomControl.mapView = mapView
        }
    }

}

#endif
