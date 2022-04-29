//
//  MapKit.swift
//  Map
//
//  Created by Paul Kraft on 29.04.22.
//

import MapKit

extension CLLocationCoordinate2D {

    func equals(to other: CLLocationCoordinate2D) -> Bool {
        latitude == other.latitude
        && longitude == other.longitude
    }

}

extension MKCoordinateRegion {

    func equals(to other: MKCoordinateRegion) -> Bool {
        center.equals(to: other.center)
        && span.equals(to: other.span)
    }

}

extension MKCoordinateSpan {

    func equals(to other: MKCoordinateSpan) -> Bool {
        latitudeDelta == other.latitudeDelta
        && longitudeDelta == other.longitudeDelta
    }

}

extension MKMapPoint {

    func equals(to other: MKMapPoint) -> Bool {
        x == other.x
        && y == other.y
    }

}
extension MKMapRect {

    func equals(to other: MKMapRect) -> Bool {
        origin.equals(to: other.origin)
        && size.equals(to: other.size)
    }

}

extension MKMapSize {

    func equals(to other: MKMapSize) -> Bool {
        width == other.width
        && height == other.height
    }

}
