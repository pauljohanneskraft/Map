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
    private var selectedContent: Content?
    private var notSelectedContent: Content?
    private var viewMapAnnotation: ViewMapAnnotation<Content>?

    // MARK: Methods

    func setup(for mapAnnotation: ViewMapAnnotation<Content>) {
        annotation = mapAnnotation.annotation
        self.viewMapAnnotation = mapAnnotation
        updateContent(for: self.isSelected)
    }
    
    private func updateContent(for selectedState: Bool) {
        guard let contentView = selectedState ? viewMapAnnotation?.selectedContent : viewMapAnnotation?.content else {
            return
        }
        controller?.view.removeFromSuperview()
        let controller = NativeHostingController(rootView: contentView)
        addSubview(controller.view)
        bounds.size = controller.preferredContentSize
        self.controller = controller
    }

    // MARK: Overrides
    override func setSelected(_ selected: Bool, animated: Bool) {
        updateContent(for: selected)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let controller = controller {
            bounds.size = controller.preferredContentSize
        }
    }

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
