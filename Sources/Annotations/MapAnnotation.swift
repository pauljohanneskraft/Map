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


public class PointAnnotation: MKPointAnnotation {
  
  public init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
    super.init()
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
  }
}

public protocol MapAnnotation {

    // MARK: Static Functions

    static func registerView(on mapView: MKMapView)

    // MARK: Properties

    var annotation: PointAnnotation { get }

    // MARK: Methods

    func view(for mapView: MKMapView) -> MKAnnotationView?

}

extension MapAnnotation {

    static var reuseIdentifier: String {
        "__MAP__" + String(describing: self) + "__MAP__"
    }

}

#endif
