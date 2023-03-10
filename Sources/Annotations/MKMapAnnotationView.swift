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

    // MARK: Computed Properties

    override var intrinsicContentSize: CGSize {
        controller?.view.intrinsicContentSize
            ?? .init(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }

    private var intrinsicContentFrame: CGRect {
        let size = intrinsicContentSize
        return CGRect(origin: .init(x: -size.width / 2, y: -size.height / 2), size: size)
    }

    // MARK: Methods

    func setup(for mapAnnotation: ViewMapAnnotation<Content>) {
        annotation = mapAnnotation.annotation
        clusteringIdentifier = mapAnnotation.clusteringIdentifier
        
        #if canImport(UIKit)
        backgroundColor = .clear
        #endif

        let controller = NativeHostingController(rootView: mapAnnotation.content, ignoreSafeArea: true)

        #if canImport(UIKit)
        controller.view.backgroundColor = .clear
        #endif

        addSubview(controller.view)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            topAnchor.constraint(equalTo: controller.view.topAnchor),
            leftAnchor.constraint(equalTo: controller.view.leftAnchor),
            rightAnchor.constraint(equalTo: controller.view.rightAnchor),
            bottomAnchor.constraint(equalTo: controller.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        self.controller = controller
        self.invalidateIntrinsicContentSize()
        
        if let anchor = mapAnnotation.anchor {
            centerOffset = .init(x: anchor.x * intrinsicContentFrame.width / 2, y: anchor.y * intrinsicContentFrame.height / 2)
        }
    }

    // MARK: Overrides

    override func prepareForReuse() {
        super.prepareForReuse()

        #if canImport(UIKit)
        controller?.willMove(toParent: nil)
        #endif
        controller?.view.removeFromSuperview()
        controller?.removeFromParent()
        controller = nil
    }

    #if canImport(UIKit)

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return intrinsicContentFrame.contains(point)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        controller?.view.frame = intrinsicContentFrame
        return controller?.view.hitTest(point, with: event) ?? super.hitTest(point, with: event)
    }

    #elseif canImport(AppKit)

    override func isMousePoint(_ point: NSPoint, in rect: NSRect) -> Bool {
        rect.contains(point)
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        controller?.view.frame = intrinsicContentFrame
        guard let view = controller?.view.hitTest(point) ?? super.hitTest(point) else {
            return nil
        }
        return view
    }

    #endif

}

#endif
