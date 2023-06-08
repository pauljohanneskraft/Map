//
//  MKMapAnnotationView.swift
//  Map
//
//  Created by Paul Kraft on 23.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

class MKMapAnnotationView<Content: View>: MKAnnotationView, UpdatableAnnotationView {

    // MARK: Stored Properties

    private var controller: NativeHostingController<Content>?
    private var mapAnnotation: ViewMapAnnotation<Content>?
    private let deferAddingContentForPreviews: Bool = false
    private let colorizeFramesForDebugging: Bool = false

    // MARK: Methods

    func update(with mapAnnotation: MapAnnotation) {
        guard let mapAnnotation = mapAnnotation as? ViewMapAnnotation<Content> else {
            assertionFailure("Attempting to update an MKMapAnnotationView with an incompatible type")
            return
        }
        self.mapAnnotation = mapAnnotation

        controller?.rootView = mapAnnotation.content
        if #available(iOS 16.0, *) {
            anchorPoint = mapAnnotation.anchorPoint
        } else {
            centerOffset = convertToCenterOffset(mapAnnotation.anchorPoint, in: bounds)
        }
        setNeedsLayout()
    }

    func setup(for mapAnnotation: ViewMapAnnotation<Content>) {
        annotation = mapAnnotation.annotation
        clusteringIdentifier = mapAnnotation.clusteringIdentifier
        self.mapAnnotation = mapAnnotation

        if !deferAddingContentForPreviews {
            addContentIfNeeded()
        }
    }

    private func addContentIfNeeded() {
        guard let mapAnnotation else { return }
        guard controller == nil else { return }

        let controller = NativeHostingController(rootView: mapAnnotation.content)
        self.controller = controller

        if colorizeFramesForDebugging {
            backgroundColor = .red
            controller.view.backgroundColor = .green
        } else {
            controller.view.backgroundColor = .clear
        }
        frame.size = controller.view.intrinsicContentSize
        addSubview(controller.view)
        controller.view.frame = bounds

        if #available(iOS 16.0, *) {
            anchorPoint = mapAnnotation.anchorPoint
        } else {
            centerOffset = convertToCenterOffset(mapAnnotation.anchorPoint, in: bounds)
        }
    }

    func convertToCenterOffset(_ anchorPoint: CGPoint, in rect: CGRect) -> CGPoint {
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

        // In previews, the height of the annotation view ends up being too big, I have no idea why there's a difference, but
        // when run on device it's not noticeable
        if deferAddingContentForPreviews && frame.origin != .zero {
            addContentIfNeeded()
        }

        guard let controller = controller else { return }

        bounds.size = controller.view.intrinsicContentSize
        // Setting the frame to zero than immediately back triggers
        // The SwiftUI frame to correctly follow the hosting view's frame in
        // The map's coordinate space. I think SwiftUI cannot correctly hook into the parent
        // view's coordinate updates because MKMapView moves the MKAnnotationView's around in
        // non-standard ways.
        controller.view.frame = .zero
        controller.view.frame = bounds
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
