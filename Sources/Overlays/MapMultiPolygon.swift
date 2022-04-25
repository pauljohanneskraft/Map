//
//  MapMultiPolygon.swift
//  Map
//
//  Created by Paul Kraft on 25.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

public struct MapMultiPolygon: MapOverlay {

    // MARK: Stored Properties

    public let overlay: MKOverlay
    public let level: MKOverlayLevel?

    private let fillColor: Color?
    private let nativeFillColor: NativeColor?
    private let lineWidth: CGFloat?
    private let strokeColor: Color?
    private let nativeStrokeColor: NativeColor?

    // MARK: Initialization

    public init(polygons: [MKPolygon], level: MKOverlayLevel? = nil, fillColor: NativeColor? = nil, lineWidth: CGFloat? = nil, strokeColor: NativeColor? = nil) {
        self.overlay = MKMultiPolygon(polygons)
        self.level = level
        self.fillColor = nil
        self.nativeFillColor = fillColor
        self.lineWidth = lineWidth
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
    }

    public init(multiPolygon: MKMultiPolygon, level: MKOverlayLevel? = nil, fillColor: NativeColor? = nil, lineWidth: CGFloat? = nil, strokeColor: NativeColor? = nil) {
        self.overlay = multiPolygon
        self.level = level
        self.fillColor = nil
        self.nativeFillColor = fillColor
        self.lineWidth = lineWidth
        self.strokeColor = nil
        self.nativeStrokeColor = strokeColor
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(polygons: [MKPolygon], level: MKOverlayLevel? = nil, fillColor: Color?, lineWidth: CGFloat? = nil, strokeColor: Color?) {
        self.overlay = MKMultiPolygon(polygons)
        self.level = level
        self.fillColor = fillColor
        self.nativeFillColor = nil
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
    }

    @available(iOS 14, macOS 11, tvOS 14, *)
    public init(multiPolygon: MKMultiPolygon, level: MKOverlayLevel? = nil, fillColor: Color?, lineWidth: CGFloat? = nil, strokeColor: Color?) {
        self.overlay = multiPolygon
        self.level = level
        self.fillColor = fillColor
        self.nativeFillColor = nil
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.nativeStrokeColor = nil
    }

    // MARK: Methods

    public func renderer(for mapView: MKMapView) -> MKOverlayRenderer {
        let renderer = (overlay as? MKMultiPolygon)
            .map { MKMultiPolygonRenderer(multiPolygon: $0) }
            ?? MKMultiPolygonRenderer(overlay: overlay)

        if let fillColor = fillColor, #available(iOS 14, macOS 11, tvOS 14, *) {
            renderer.fillColor = .init(fillColor)
        } else if let fillColor = nativeFillColor {
            renderer.fillColor = fillColor
        }
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
