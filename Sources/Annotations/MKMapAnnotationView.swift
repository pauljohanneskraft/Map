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
        addSubview(controller.view)
        bounds.size = controller.preferredContentSize
        self.controller = controller
        
        if #available(iOS 16, *) {
            anchorPoint = mapAnnotation.anchorPoint
        } else {
            centerOffset = anchorPointToCenterOffset(mapAnnotation.anchorPoint, in: bounds)
        }
    }

    // Only necessary for iOS < 16, where `anchorPoint` is not available on `UIView`
    func anchorPointToCenterOffset(_ anchorPoint: CGPoint, in rect: CGRect) -> CGPoint {
        assert((0.0...1.0).contains(anchorPoint.x), "Valid anchor point range is 0.0 to 1.0, received x value: \(anchorPoint.x)")
        assert((0.0...1.0).contains(anchorPoint.y), "Valid anchor point range is 0.0 to 1.0, received y value: \(anchorPoint.y)")

        return .init(
            x: (0.5 - anchorPoint.x) * rect.width,
            y: (0.5 - anchorPoint.y) * rect.height
        )
    }


    // MARK: Overrides

    #if canImport(UIKit)

    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let controller else {
            return
        }

        bounds.size = controller.preferredContentSize
        if #unavailable(iOS 16), let mapAnnotation {
            centerOffset = anchorPointToCenterOffset(mapAnnotation.anchorPoint, in: bounds)
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
