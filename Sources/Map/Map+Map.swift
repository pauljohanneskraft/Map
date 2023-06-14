//
//  Map+Map.swift
//  Map
//
//  Created by Niccari on 12.06.22.
//

import Foundation
import MapKit

#if !os(watchOS)

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

        #if canImport(AppKit) && !canImport(UIKit)
        let screenScale = NSScreen.main?.backingScaleFactor ?? 1
        #elseif canImport(UIKit)
        let screenScale = UIScreen.main.scale
        #endif
        let tappedItems = mapView.overlays.filter {
            overlay in

            guard let renderer: MKOverlayPathRenderer = mapView.renderer(for: overlay) as? MKOverlayPathRenderer else { return false }
            let currentMapPoint: MKMapPoint = MKMapPoint(locationCoordinate)
            let viewPoint: CGPoint = renderer.point(for: currentMapPoint)
            var targetPath = renderer.path

            if renderer is MKPolylineRenderer || renderer is MKMultiPolylineRenderer {
                targetPath = targetPath?.copy(
                    strokingWithWidth: renderer.lineWidth * scale * screenScale,
                    lineCap: renderer.lineCap,
                    lineJoin: renderer.lineJoin,
                    miterLimit: renderer.miterLimit
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

#endif
