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

        let zoomLevel = log2(360.0 * ((Double(mapView.frame.size.width) / 256.0) / mapView.region.span.longitudeDelta)) + 1.0
        let scale = pow(2, 20 - zoomLevel)

        let tappedItems = mapView.overlays.filter {
            overlay in

            guard let renderer: MKOverlayPathRenderer = mapView.renderer(for: overlay) as? MKOverlayPathRenderer else { return false }
            let currentMapPoint: MKMapPoint = MKMapPoint(locationCoordinate)
            let viewPoint: CGPoint = renderer.point(for: currentMapPoint)
            var targetPath = renderer.path

            if renderer is MKPolylineRenderer || renderer is MKMultiPolygonRenderer {
                targetPath = targetPath?.copy(
                    strokingWithWidth: renderer.lineWidth * scale * UIScreen.main.scale,
                    lineCap: .square,
                    lineJoin: .bevel,
                    miterLimit: .greatestFiniteMagnitude
                )
            }
            guard let targetPath = targetPath else { return false }
            return targetPath.contains(viewPoint)
        }

        if let tappedItem = tappedItems.last {
            if let id = overlayContentByID.first(where: { $0.value.overlay.hash == tappedItem.hash })?.key {
                if let item = self.overlayItems.first(where: { $0.id == id }) {
                    onOverlayTapped?(item)
                    return
                }
            }
        }
    }

}
