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

    // MARK: Methods

    func setup(for mapAnnotation: ViewMapAnnotation<Content>) {
        annotation = mapAnnotation.annotation
        backgroundColor = .clear

        let controller = NativeHostingController(rootView: mapAnnotation.content)
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(controller.view)
        NSLayoutConstraint.activate([
            controller.view.centerXAnchor.constraint(equalTo: centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: centerYAnchor),
            controller.view.widthAnchor.constraint(equalTo: widthAnchor),
            controller.view.heightAnchor.constraint(equalTo: heightAnchor),
        ])

        self.isUserInteractionEnabled = true
        self.controller = controller
        self.invalidateIntrinsicContentSize()
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

    override func layoutSubviews() {
        super.layoutSubviews()

        controller?.view.frame = calculateIntrinsicContentFrame()
    }

    /*
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        controller?.view.frame = calculateIntrinsicContentFrame()
        calculateIntrinsicContentFrame().contains(point)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        controller?.view.frame = calculateIntrinsicContentFrame()
        guard let view = controller?.view.hitTest(point, with: event) ?? super.hitTest(point, with: event) else {
            return nil
        }
        superview?.bringSubviewToFront(self)
        return view
    }
     */

    private func calculateIntrinsicContentFrame() -> CGRect {
        let size = controller?.view.intrinsicContentSize ?? .zero
        return CGRect(origin: .init(x: -size.width / 2, y: -size.height / 2), size: size)
    }

}

#endif
