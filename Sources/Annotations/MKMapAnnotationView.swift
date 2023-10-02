//
//  MKMapAnnotationView.swift
//  Map
//
//  Created by Paul Kraft on 23.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

class MKMapAnnotationView<Content: View>: MKAnnotationView {

    // MARK: Stored Properties

    private var controller: NativeHostingController<Content>?
    private var mapAnnotation: ViewMapAnnotation<Content>?

    // MARK: Methods

    func setup(for mapAnnotation: ViewMapAnnotation<Content>) {
        self.mapAnnotation = mapAnnotation
        annotation = mapAnnotation.annotation
        clusteringIdentifier = mapAnnotation.clusteringIdentifier
        
        displayPriority = mapAnnotation.displayPriority
        collisionMode = mapAnnotation.collisionMode

        let controller = NativeHostingController(rootView: mapAnnotation.content)
        self.controller = controller

        frame.size = controller.view.intrinsicContentSize
        addSubview(controller.view)
        controller.view.frame = bounds

        #if canImport(UIKit)
        controller.view.backgroundColor = .clear
        #endif
        
        if #available(iOS 16, *) {
            anchorPoint = mapAnnotation.anchorPoint.toCGPoint()
        } else {
            centerOffset = mapAnnotation.anchorPoint.toCenterOffset(in: bounds)
        }
    }

    // MARK: Overrides

    #if canImport(UIKit)

    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let controller else {
            return
        }

        bounds.size = controller.view.intrinsicContentSize
        // Setting the frame to zero than immediately back triggers the SwiftUI frame to correctly
        // follow the hosting view's frame in The map's coordinate space. It seems SwiftUI cannot
        // correctly hook into the parent view's coordinate updates because MKMapView moves the
        // MKAnnotationView's around in non-standard ways.
        controller.view.frame = .zero
        controller.view.frame = bounds
        
        if #unavailable(iOS 16), let mapAnnotation {
            centerOffset = mapAnnotation.anchorPoint.toCenterOffset(in: bounds)
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
        
        mapAnnotation = nil
        annotation = nil
    }

}

#endif
