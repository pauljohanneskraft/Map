//
//  MKOverlay.swift
//  
//
//  Created by Niccari on 12/06/2022.
//

import Foundation
import MapKit

extension MKOverlay {

    // MARK: Methods

    func contains(_ coordinate2D: CLLocationCoordinate2D) -> Bool {
        let renderer = MKOverlayPathRenderer(overlay: self)
        let currentMapPoint: MKMapPoint = MKMapPoint(coordinate2D)
        let viewPoint: CGPoint = renderer.point(for: currentMapPoint)
        if renderer.path == nil {
            return false
        } else {
            if self is MKPolyline || self is MKMultiPolyline {
                // FIXME:
                let path = renderer.path.copy(
                    strokingWithWidth: 5.0,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: .greatestFiniteMagnitude
                )
                return path.contains(viewPoint)
            } else {
                return renderer.path.contains(viewPoint)
            }
        }
    }
}
