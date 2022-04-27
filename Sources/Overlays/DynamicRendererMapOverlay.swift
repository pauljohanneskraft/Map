//
//  DynamicRendererMapOverlay.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if !os(watchOS)

import Combine
import MapKit

public struct DynamicRendererMapOverlay: MapOverlay {

    // MARK: Nested Types

    public struct DisplayRequest {

        // MARK: Stored Properties

        let mapRect: MKMapRect?
        let zoomScale: MKZoomScale?

        // MARK: Initialization

        public init(mapRect: MKMapRect? = nil) {
            self.mapRect = mapRect
            self.zoomScale = nil
        }

        public init(mapRect: MKMapRect, zoomScale: MKZoomScale?) {
            self.mapRect = mapRect
            self.zoomScale = zoomScale
        }

    }

    // MARK: Stored Properties

    public let overlay: MKOverlay
    public let level: MKOverlayLevel?
    private let displayRequestPublisher: AnyPublisher<DisplayRequest, Never>
    private let canDraw: ((MKMapRect, MKZoomScale) -> Bool)?
    private let draw: (MKMapRect, MKZoomScale, CGContext) -> Void

    // MARK: Initialization

    public init<P: Publisher>(
        overlay: MKOverlay,
        level: MKOverlayLevel? = nil,
        publisher: P,
        canDraw: ((MKMapRect, MKZoomScale) -> Bool)? = nil,
        draw: @escaping (MKMapRect, MKZoomScale, CGContext) -> Void
    ) where P.Output == DisplayRequest, P.Failure == Never {

        self.overlay = overlay
        self.level = level
        self.displayRequestPublisher = publisher.eraseToAnyPublisher()
        self.canDraw = canDraw
        self.draw = draw
    }


    public func renderer(for mapView: MKMapView) -> MKOverlayRenderer {
        DynamicMapRenderer(
            overlay: overlay,
            displayRequestPublisher: displayRequestPublisher,
            canDraw: canDraw,
            draw: draw
        )
    }

}

private class DynamicMapRenderer: MKOverlayRenderer {

    // MARK: Stored Properties

    let _canDraw: ((MKMapRect, MKZoomScale) -> Bool)?
    let _draw: (MKMapRect, MKZoomScale, CGContext) -> Void
    var cancellables = Set<AnyCancellable>()

    // MARK: Initialization

    init(overlay: MKOverlay,
         displayRequestPublisher: AnyPublisher<DynamicRendererMapOverlay.DisplayRequest, Never>,
         canDraw: ((MKMapRect, MKZoomScale) -> Bool)?,
         draw: @escaping (MKMapRect, MKZoomScale, CGContext) -> Void) {

        self._canDraw = canDraw
        self._draw = draw
        super.init(overlay: overlay)

        displayRequestPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] request in
                guard let mapRect = request.mapRect else {
                    self.setNeedsDisplay()
                    return
                }
                guard let zoomScale = request.zoomScale else {
                    self.setNeedsDisplay(mapRect)
                    return
                }
                self.setNeedsDisplay(mapRect, zoomScale: zoomScale)
            }
            .store(in: &cancellables)
    }

    // MARK: Overrides

    override func canDraw(_ mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
        _canDraw?(mapRect, zoomScale) ?? super.canDraw(mapRect, zoomScale: zoomScale)
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        _draw(mapRect, zoomScale, context)
    }

}

#endif
