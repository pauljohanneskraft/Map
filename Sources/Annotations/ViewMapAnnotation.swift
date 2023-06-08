//
//  ViewMapAnnotation.swift
//  Map
//
//  Created by Paul Kraft on 23.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

public struct ViewMapAnnotation<Content: View, DetailCalloutAccessory: View>: MapAnnotation {

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
        mapView.register(MKMapAnnotationView<Content, DetailCalloutAccessory>.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: Stored Properties

    public let annotation: MKAnnotation
    let clusteringIdentifier: String?
    let content: Content
    let detailCalloutAccessory: DetailCalloutAccessory

    // MARK: Initialization

    public init(
        coordinate: CLLocationCoordinate2D,
        title: String? = nil,
        subtitle: String? = nil,
        clusteringIdentifier: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder detailCalloutAccessory: () -> DetailCalloutAccessory = { EmptyView() }
    ) {
        self.annotation = Annotation(coordinate: coordinate, title: title, subtitle: subtitle)
        self.detailCalloutAccessory = detailCalloutAccessory()
        self.clusteringIdentifier = clusteringIdentifier
        self.content = content()
    }

    public init(
        annotation: MKAnnotation,
        clusteringIdentifier: String? = nil,
        @ViewBuilder content: () -> Content,
        @ViewBuilder detailCalloutAccessory: () -> DetailCalloutAccessory = { EmptyView() }
    ) {
        self.annotation = annotation
        self.detailCalloutAccessory = detailCalloutAccessory()
        self.clusteringIdentifier = clusteringIdentifier
        self.content = content()
    }

    // MARK: Methods

    public func view(for mapView: MKMapView) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: Self.reuseIdentifier,
            for: annotation
        ) as? MKMapAnnotationView<Content, DetailCalloutAccessory>

        view?.setup(for: self)
        return view
    }

}

#endif
