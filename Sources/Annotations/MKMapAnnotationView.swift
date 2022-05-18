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

    // MARK: Methods

    func setup(for mapAnnotation: ViewMapAnnotation<Content>) {
        annotation = mapAnnotation.annotation

        let controller = NativeHostingController(rootView: mapAnnotation.content)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(controller.view)
        NSLayoutConstraint.activate([
            controller.view.centerXAnchor.constraint(equalTo: centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: centerYAnchor),
            controller.view.widthAnchor.constraint(equalTo: widthAnchor),
            controller.view.heightAnchor.constraint(equalTo: heightAnchor),
        ])
        self.controller = controller
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

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let result = controller?.view.point(inside: point, with: event) ?? false
        print(#function, point, result)
        return result
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = controller?.view.hitTest(point, with: event) ?? super.hitTest(point, with: event) else {
            print(#function, point, "nil")
            return nil
        }
        print(#function, point, view)
        superview?.bringSubviewToFront(self)
        return view
    }

}

#endif
