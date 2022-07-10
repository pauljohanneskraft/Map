//
//  MapUserTrackingButton.swift
//  Map
//
//  Created by Paul Kraft on 03.07.22.
//

#if canImport(UIKit) && !os(watchOS)

import SwiftUI
import MapKit

public struct MapUserTrackingButton {

    // MARK: Stored Properties

    private let key: AnyHashable

    // MARK: Initialization

    public init<Key: Hashable>(key: Key) {
        self.key = key
    }

}

// MARK: - UIViewRepresentable

extension MapUserTrackingButton: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKUserTrackingButton {
        let view = MKUserTrackingButton(mapView: MapRegistry[key])
        updateUIView(view, context: context)
        return view
    }

    public func updateUIView(_ view: MKUserTrackingButton, context: Context) {
        if let mapView = MapRegistry[key], mapView != view.mapView {
            view.mapView = mapView
        }
    }

}

#endif
