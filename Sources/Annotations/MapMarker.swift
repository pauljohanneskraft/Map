//
//  MapMarker.swift
//  Map
//
//  Created by Paul Kraft on 22.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

@available(macOS 11, *)
public struct MapMarker {

    // MARK: Nested Types

    private class Annotation: NSObject, MKAnnotation {

        // MARK: Stored Properties

        let coordinate: CLLocationCoordinate2D
        let detailCalloutAccessoryView: AnyView?

        // MARK: Initialization

        init(_ coordinate: CLLocationCoordinate2D, detailCalloutAccessoryView: AnyView?) {
            self.coordinate = coordinate
            self.detailCalloutAccessoryView = detailCalloutAccessoryView
        }

    }

    // MARK: Stored Properties

    private let coordinate: CLLocationCoordinate2D
    private let tint: Color?
    private let nativeTint: NativeColor?
    public let annotation: MKAnnotation

    // MARK: Initialization

    public init(coordinate: CLLocationCoordinate2D, tint: NativeColor? = nil, detailCalloutAccessoryView: AnyView? = nil) {
        self.coordinate = coordinate
        self.tint = nil
        self.nativeTint = tint
        self.annotation = Annotation(coordinate, detailCalloutAccessoryView: detailCalloutAccessoryView)
    }

    @available(iOS 14, tvOS 14, *)
    public init(coordinate: CLLocationCoordinate2D, tint: Color?, detailCalloutAccessoryView: AnyView? = nil) {
        self.coordinate = coordinate
        self.tint = tint
        self.nativeTint = nil
        self.annotation = Annotation(coordinate, detailCalloutAccessoryView: detailCalloutAccessoryView)
    }

}

// MARK: - MapAnnotation

@available(macOS 11, *)
extension MapMarker: MapAnnotation {

    public static func registerView(on mapView: MKMapView) {
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: reuseIdentifier)
    }

    public func view(for mapView: MKMapView) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: Self.reuseIdentifier, for: annotation)
        view.annotation = annotation
        if let mapMarkerAnnotation = annotation as? MapMarker.Annotation, let detailCalloutAccessoryView = mapMarkerAnnotation.detailCalloutAccessoryView {
            view.canShowCallout = true
            view.detailCalloutAccessoryView = NativeHostingController(rootView: detailCalloutAccessoryView).view
        }
        if let marker = view as? MKMarkerAnnotationView {
            if #available(iOS 14, tvOS 14, *), let tint = tint {
                marker.markerTintColor = .init(tint)
            } else if let tint = nativeTint {
                marker.markerTintColor = tint
            }
        }
        return view
    }

}

#endif
