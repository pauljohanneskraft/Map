//
//  MapCompass.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//


#if !os(tvOS) && !os(watchOS)

import SwiftUI
import MapKit

@available(macOS 11, *)
public struct MapCompass<Key: MapKey> {

    // MARK: Nested Types

    public class Coordinator {

        // MARK: Stored Properties

        private var view: MapCompass?

        // MARK: Methods

        func update(_ compassButton: MKCompassButton, with newView: MapCompass, context: Context) {
            defer { view = newView }

            if view?.visibility != newView.visibility {
                compassButton.compassVisibility = newView.visibility
            }
        }

    }

    // MARK: Stored Properties

    private let visibility: MKFeatureVisibility

    // MARK: Initialization

    public init(key: Key.Type, visibility: MKFeatureVisibility) {
        self.visibility = visibility
    }

    // MARK: Methods

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

}

#if canImport(UIKit)

@available(macOS 11, *)
extension MapCompass: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKCompassButton {
        let view = MKCompassButton(mapView: MapRegistry[Key.self])
        updateUIView(view, context: context)
        return view
    }

    public func updateUIView(_ compassButton: MKCompassButton, context: Context) {
        compassButton.mapView = MapRegistry[Key.self]
        context.coordinator.update(compassButton, with: self, context: context)
    }

}

#elseif canImport(AppKit)

@available(macOS 11, *)
extension MapCompass: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKCompassButton {
        let view = MKCompassButton(mapView: MapRegistry[Key.self])
        updateNSView(view, context: context)
        return view
    }

    public func updateNSView(_ compassButton: MKCompassButton, context: Context) {
        compassButton.mapView = MapRegistry[Key.self]
        context.coordinator.update(compassButton, with: self, context: context)
    }

}

#endif

#endif
