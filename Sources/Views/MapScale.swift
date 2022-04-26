//
//  MapScale.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if canImport(UIKit) && !os(watchOS)

import SwiftUI
import MapKit

public struct MapScale {

    // MARK: Nested Types

    public class Coordinator {

        // MARK: Stored Properties

        private var view: MapScale?

        // MARK: Methods

        func update(_ scaleView: MKScaleView, with newView: MapScale, context: Context) {
            defer { view = newView }

            if view?.visibility != newView.visibility {
                scaleView.scaleVisibility = newView.visibility
            }

            if view?.alignment != newView.alignment {
                scaleView.legendAlignment = newView.alignment
            }
        }

    }

    // MARK: Stored Properties

    private let key: AnyHashable
    private let alignment: MKScaleView.Alignment
    private let visibility: MKFeatureVisibility

    // MARK: Initialization

    public init<Key: Hashable>(key: Key, alignment: MKScaleView.Alignment, visibility: MKFeatureVisibility) {
        self.key = key
        self.alignment = alignment
        self.visibility = visibility
    }

    // MARK: Methods

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

}

// MARK: - UIViewRepresentable

extension MapScale: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKScaleView {
        let view = MKScaleView(mapView: MapRegistry[key])
        updateUIView(view, context: context)
        return view
    }

    public func updateUIView(_ scaleView: MKScaleView, context: Context) {
        if let mapView = MapRegistry[key], mapView != scaleView.mapView {
            scaleView.mapView = mapView
        }
        context.coordinator.update(scaleView, with: self, context: context)
    }

}

#endif
