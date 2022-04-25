//
//  MapOverlay.swift
//  Map
//
//  Created by Paul Kraft on 22.04.22.
//

import Foundation
import MapKit

#if !os(watchOS)

public protocol MapOverlay {

    // MARK: Properties

    var overlay: MKOverlay { get }
    var level: MKOverlayLevel? { get }

    // MARK: Methods

    func renderer(for mapView: MKMapView) -> MKOverlayRenderer

}

#endif
