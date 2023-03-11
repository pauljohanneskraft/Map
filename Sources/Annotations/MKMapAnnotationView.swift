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

    func update(for mapAnnotation: ViewMapAnnotation<Content>) {
        controller?.rootView = mapAnnotation.content
        if #available(iOS 16.0, *) {
            anchorPoint = mapAnnotation.anchorPoint
        } else {
            // Fallback on earlier versions
        }
        setNeedsLayout()
    }

    func setup(for mapAnnotation: ViewMapAnnotation<Content>) {
        annotation = mapAnnotation.annotation
        clusteringIdentifier = mapAnnotation.clusteringIdentifier
        self.mapAnnotation = mapAnnotation
    }

    private func addContentIfNeeded() {
        guard let mapAnnotation else { return }
        guard controller == nil else { return }

        let controller = NativeHostingController(rootView: mapAnnotation.content)
        controller.view.backgroundColor = .clear
        addSubview(controller.view)
        bounds.size = controller.sizeThatFits(in: .init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        self.controller = controller
        if #available(iOS 16.0, *) {
            anchorPoint = mapAnnotation.anchorPoint
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: Overrides

    #if canImport(UIKit)

    override func layoutSubviews() {
        super.layoutSubviews()

        // Deferring the addition of the SwiftUI hosting view until the layout pass
        // Seems to guarantee more accurate sizes on the first view update
        addContentIfNeeded()

        if let controller = controller {
            bounds.size = controller.sizeThatFits(in: .init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            // Setting the frame to zero than immediately back triggers
            // The SwiftUI frame to correctly follow the hosting view's frame in
            // The map's coordinate space. I think SwiftUI cannot correctly hook into the parent
            // view's coordinate updates because MKMapView moves the MKAnnotationView's around in
            // non-standard ways.
            controller.view.frame = .zero
            controller.view.frame = bounds
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
