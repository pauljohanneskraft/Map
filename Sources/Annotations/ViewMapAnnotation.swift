//
//  ViewMapAnnotation.swift
//  Map
//
//  Created by Paul Kraft on 23.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

public struct ViewMapAnnotation<Content: View, DetailCalloutAccessoryView: View>: MapAnnotation {

    // MARK: Nested Types

    class Annotation: NSObject, MKAnnotation {

        // MARK: Stored Properties

        let coordinate: CLLocationCoordinate2D
        let title: String?
        let subtitle: String?

        // MARK: Initialization

        init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }

    }

    // MARK: Static Functions

    public static func registerView(on mapView: MKMapView) {
        mapView.register(MKMapAnnotationView<Content, DetailCalloutAccessoryView>.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: Stored Properties

    public let annotation: MKAnnotation
    let clusteringIdentifier: String?
    let detailCalloutAccessoryView: DetailCalloutAccessoryView?
    let content: Content

    // MARK: Initialization

    public init(
        coordinate: CLLocationCoordinate2D,
        title: String? = nil,
        subtitle: String? = nil,
        detailCalloutAccessoryView: DetailCalloutAccessoryView? = nil,
        clusteringIdentifier: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.annotation = Annotation(coordinate: coordinate, title: title, subtitle: subtitle)
        self.detailCalloutAccessoryView = detailCalloutAccessoryView
        self.clusteringIdentifier = clusteringIdentifier
        self.content = content()
    }

    public init(
        annotation: MKAnnotation,
        detailCalloutAccessoryView: DetailCalloutAccessoryView? = nil,
        clusteringIdentifier: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.annotation = annotation
        self.detailCalloutAccessoryView = detailCalloutAccessoryView
        self.clusteringIdentifier = clusteringIdentifier
        self.content = content()
    }

    // MARK: Methods

    public func view(for mapView: MKMapView) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: Self.reuseIdentifier,
            for: annotation
        ) as? MKMapAnnotationView<Content, DetailCalloutAccessoryView>

        view?.setup(for: self)
        return view
    }

}

#endif
