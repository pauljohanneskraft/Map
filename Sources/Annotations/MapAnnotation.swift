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
  public var heading: Double
  
  public init(coordinate: CLLocationCoordinate2D, heading: Double = 0, title: String? = nil, subtitle: String? = nil) {
    self.heading = heading
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
