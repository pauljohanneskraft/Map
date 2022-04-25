//
//  MapPolyline.swift
//  Map
//
//  Created by Paul Kraft on 22.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

public struct MapPolyline: MapOverlay {

    // MARK: Stored Properties

    public let overlay: MKOverlay
    public let level: MKOverlayLevel?

    private let lineWidth: CGFloat?
    private let strokeColor: Color?
    private let nativeStrokeColor: NativeColor?
    
    // MARK: Initialization

    public init(coordinates: [CLLocationCoordinate2D], level: MKOverlayLevel? = nil, strokeColor: NativeColor? = nil, lineWidth: CGFloat? = nil) {
        self.overlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.level = level
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
        self.lineWidth = lineWidth
    }

    public init(points: [MKMapPoint], level: MKOverlayLevel? = nil, strokeColor: NativeColor? = nil, lineWidth: CGFloat? = nil) {
        self.overlay = MKPolyline(points: points, count: points.count)
        self.level = level
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
        self.lineWidth = lineWidth
    }

    public init(polyline: MKPolyline, level: MKOverlayLevel? = nil, strokeColor: NativeColor? = nil, lineWidth: CGFloat? = nil) {
        self.overlay = polyline
        self.level = level
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
        self.lineWidth = lineWidth
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(coordinates: [CLLocationCoordinate2D], level: MKOverlayLevel? = nil, strokeColor: Color?, lineWidth: CGFloat? = nil) {
        self.overlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.level = level
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
        self.lineWidth = lineWidth
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(points: [MKMapPoint], level: MKOverlayLevel? = nil, strokeColor: Color?, lineWidth: CGFloat? = nil) {
        self.overlay = MKPolyline(points: points, count: points.count)
        self.level = level
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
        self.lineWidth = lineWidth
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(polyline: MKPolyline, level: MKOverlayLevel? = nil, strokeColor: Color?, lineWidth: CGFloat? = nil) {
        self.overlay = polyline
        self.level = level
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
        self.lineWidth = lineWidth
    }

    // MARK: Methods

    public func renderer(for mapView: MKMapView) -> MKOverlayRenderer {
        let renderer = (overlay as? MKPolyline)
            .map { MKPolylineRenderer(polyline: $0) }
            ?? MKPolylineRenderer(overlay: overlay)

        if let lineWidth = lineWidth {
            renderer.lineWidth = lineWidth
        }
        if let strokeColor = strokeColor, #available(iOS 14, macOS 11, tvOS 14, *) {
            renderer.strokeColor = .init(strokeColor)
        } else if let strokeColor = nativeStrokeColor {
            renderer.strokeColor = strokeColor
        }

        return renderer
    }

}

#endif
