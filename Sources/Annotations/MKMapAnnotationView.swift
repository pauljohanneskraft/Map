//
//  MKMapAnnotationView.swift
//  Map
//
//  Created by Paul Kraft on 23.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

class MKMapAnnotationView<Content: View, DetailCalloutAccessory: View>: MKAnnotationView {

    // MARK: Stored Properties

    private var controller: NativeHostingController<Content>?

    // MARK: Methods

    func setup(for mapAnnotation: ViewMapAnnotation<Content, DetailCalloutAccessory>) {
        annotation = mapAnnotation.annotation
        clusteringIdentifier = mapAnnotation.clusteringIdentifier

        if DetailCalloutAccessory.self != EmptyView.self {
            canShowCallout = true
            detailCalloutAccessoryView = NativeHostingController(rootView: mapAnnotation.detailCalloutAccessory).view
        }
        
        let controller = NativeHostingController(rootView: mapAnnotation.content)
        addSubview(controller.view)
        bounds.size = controller.preferredContentSize
        self.controller = controller
    }

    // MARK: Overrides

    #if canImport(UIKit)

    override func layoutSubviews() {
        super.layoutSubviews()

        if let controller = controller {
            bounds.size = controller.preferredContentSize
        }
    }

    #endif

    override func prepareForReuse() {
        super.prepareForReuse()

        #if canImport(UIKit)
        controller?.willMove(toParent: nil)
        #endif
        controller?.view.removeFromSuperview()
        controller?.removeFromParent()
        controller = nil
    }

}

#endif
