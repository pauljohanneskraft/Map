//
//  MapOverlayRenderer.swift
//  Map
//
//  Created by Paul Kraft on 23.04.22.
//

#if !os(watchOS)

import Foundation
import MapKit

public struct RendererMapOverlay: MapOverlay {

    // MARK: Stored Properties

    public let overlay: MKOverlay
    public let level: MKOverlayLevel?
    private let _renderer: (MKMapView, MKOverlay) -> MKOverlayRenderer

    // MARK: Initialization

    public init(overlay: MKOverlay, level: MKOverlayLevel? = nil, renderer: @escaping (MKMapView, MKOverlay) -> MKOverlayRenderer) {
        self.overlay = overlay
        self.level = level
        self._renderer = renderer
    }

    // MARK: Methods

    public func renderer(for mapView: MKMapView) -> MKOverlayRenderer {
        _renderer(mapView, overlay)
    }

}

#endif
