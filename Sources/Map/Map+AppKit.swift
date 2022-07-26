//
//  Map+AppLot.swift
//  
//
//  Created by Paul Kraft on 25.04.22.
//

#if canImport(AppKit) && !canImport(UIKit)

import AppKit
import MapKit
import SwiftUI

extension Map: NSViewRepresentable {

    public func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        updateNSView(mapView, context: context)

        let gesture = NSClickGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.tapped)
        )
        mapView.addGestureRecognizer(gesture)
        return mapView
    }

    public func updateNSView(_ mapView: MKMapView, context: Context) {
        context.coordinator.update(mapView, from: self, context: context)
    }

}

#endif
