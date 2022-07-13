//
//  MovableViewMapAnnotation.swift
//  Map
//
//  Created by Alex Reilly on 12.07.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

public struct MovableViewMapAnnotation<Content: View>: MapAnnotation {
    // MARK: Nested Types
    
    // MARK: Static Functions
    
    public static func registerView(on mapView: MKMapView) {
        mapView.register(MKMapAnnotationView<Content>.self, forAnnotationViewWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: Stored Properties
    
    public var annotation: PointAnnotation
    let content: Content
    
    // MARK: Initialization
    
    public init(
        coordinate: CLLocationCoordinate2D,
        heading: Double,
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        let pointAnnotation = PointAnnotation(coordinate: coordinate, heading: heading, title: title, subtitle: subtitle)
        self.annotation = pointAnnotation
        self.content = content()
    }
    
    //  public init(
    //    annotation: MKPointAnnotation,
    //    @ViewBuilder content: () -> Content
    //  ) {
    //    self.annotation = annotation
    //    self.content = content()
    //  }
    
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
