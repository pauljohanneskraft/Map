//
//  File.swift
//  
//
//  Created by Niccari on 12/06/2022.
//

import Foundation
import MapKit

extension Map {

    // MARK: Methods

    func processTapEvent(
        for mapView: MKMapView,
        of overlayContentByID: [OverlayItems.Element.ID: MapOverlay],
        on touchLocation: CGPoint
    ) {
        let locationCoordinate = mapView.convert(
            touchLocation, toCoordinateFrom: mapView.self)

        let tappedItems = mapView.overlays.filter {
            overlay in

            // FIXME: predefine renderer
            let renderer: MKOverlayPathRenderer
            if overlay is MKCircle {
                renderer = MKCircleRenderer(circle: overlay as! MKCircle)
            } else if overlay is MKPolyline {
                renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            } else if overlay is MKPolygon {
                renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            } else {
                fatalError("unsupported type")
            }
            let currentMapPoint: MKMapPoint = MKMapPoint(locationCoordinate)
            let viewPoint: CGPoint = renderer.point(for: currentMapPoint)

            var targetPath = renderer.path
            if overlay is MKPolyline {
                targetPath = targetPath?.copy(
                    strokingWithWidth: 5.0,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: .greatestFiniteMagnitude
                )
            }
            return targetPath != nil && targetPath!.contains(viewPoint)
        }

        if let tappedItem = tappedItems.first {
            if let id = overlayContentByID.first(where: { $0.value.overlay.hash == tappedItem.hash })?.key {
                if let item = self.overlayItems.first(where: { $0.id == id }) {
                    onOverlayTapped?(item)
                    return
                }
            }
        }
    }

}
