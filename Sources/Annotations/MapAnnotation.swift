//
//  MapAnnotation.swift
//  Map
//
//  Created by Paul Kraft on 22.04.22.
//

import MapKit

#if canImport(WatchKit) && os(watchOS)

import WatchKit

public protocol MapAnnotation {

    func addAnnotation(to map: WKInterfaceMap)

}

#else

public protocol MapAnnotation {

    // MARK: Static Functions

    static func registerView(on mapView: MKMapView)

    // MARK: Properties

    var annotation: MKAnnotation { get }

    // MARK: Methods

    func view(for mapView: MKMapView) -> MKAnnotationView?

}

protocol UpdatableAnnotationView {
    func update(with associatedAnnotation: MapAnnotation)
}

extension MapAnnotation {

    static var reuseIdentifier: String {
        "__MAP__" + String(describing: self) + "__MAP__"
    }

}

#endif
