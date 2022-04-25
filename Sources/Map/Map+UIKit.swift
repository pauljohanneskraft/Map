//
//  Map+UIKit.swift
//  Map
//
//  Created by Paul Kraft on 25.04.22.
//

#if canImport(UIKit) && !os(watchOS)

import MapKit
import UIKit
import SwiftUI

extension Map: UIViewRepresentable {

    public func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        updateUIView(mapView, context: context)
        return mapView
    }

    public func updateUIView(_ mapView: MKMapView, context: Context) {
        context.coordinator.update(mapView, from: self, context: context)
    }

}

#endif
