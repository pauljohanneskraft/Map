//
//  ViewMapAnnotation.swift
//  Map
//
//  Created by Paul Kraft on 23.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

public struct ViewMapAnnotation<Content: View>: MapAnnotation {
  
    // MARK: Nested Types
    private class Annotation: MKPointAnnotation { }

    // MARK: Static Functions

    public static func registerView(on mapView: MKMapView) {
        mapView.register(MKMapAnnotationView<Content>.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: Stored Properties

    public let annotation: MKAnnotation
    let content: Content

    // MARK: Initialization

    
    /// Create an annotation from a custom SwiftUI view
    /// - Parameters:
    ///   - coordinate: Where on the map to put the annotation
    ///   - heading: The direction the annotation should be oriented in degrees
    ///   - subtitle: Subtitle of the annotation
    ///   - content: Title of the annotation
    public init(
        coordinate: CLLocationCoordinate2D,
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.annotation = Annotation(__coordinate: coordinate, title: title, subtitle: subtitle)
        self.content = content()
    }

    public init(
        annotation: MKAnnotation,
        @ViewBuilder content: () -> Content
    ) {
        self.annotation = annotation
        self.content = content()
    }

    // MARK: Methods

    public func view(for mapView: MKMapView) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: Self.reuseIdentifier,
            for: annotation
        ) as? MKMapAnnotationView<Content>
        view?.setup(for: self)
        return view
    }

}

#endif
