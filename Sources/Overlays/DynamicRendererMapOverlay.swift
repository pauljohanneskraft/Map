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
    
    public struct Update {
        
        // MARK: Stored Properties
        
        let coordinate: CLLocationCoordinate2D?
        let boundingMapRect: MKMapRect?
        let displayRequest: DisplayRequest?
        
        // MARK: Initialization
        
        public init(
            coordinate: CLLocationCoordinate2D? = nil, 
            boundingMapRect: MKMapRect? = nil,
            displayRequest: DisplayRequest? = nil
        ) {
            self.coordinate = coordinate
            self.boundingMapRect = boundingMapRect
            self.displayRequest = displayRequest
        }
        
    }

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
    
    class Overlay: NSObject, MKOverlay {
        
        // MARK: Stored Properties
        
        @objc dynamic var coordinate: CLLocationCoordinate2D
        @objc dynamic var boundingMapRect: MKMapRect
        
        // MARK: Initialization
        
        init(coordinate: CLLocationCoordinate2D, boundingMapRect: MKMapRect) {
            self.coordinate = coordinate
            self.boundingMapRect = boundingMapRect
        }
        
    }

    // MARK: Stored Properties

    public let overlay: MKOverlay
    public let level: MKOverlayLevel?
    private let updatePublisher: AnyPublisher<Update, Never>
    private let canDraw: ((MKMapRect, MKZoomScale) -> Bool)?
    private let draw: (MKMapRect, MKZoomScale, CGContext) -> Void

    // MARK: Initialization

    public init<P: Publisher>(
        coordinate: CLLocationCoordinate2D,
        boundingMapRect: MKMapRect,
        level: MKOverlayLevel? = nil,
        updates: P,
        canDraw: ((MKMapRect, MKZoomScale) -> Bool)? = nil,
        draw: @escaping (MKMapRect, MKZoomScale, CGContext) -> Void
    ) where P.Output == Update, P.Failure == Never {

        self.overlay = Overlay(coordinate: coordinate, boundingMapRect: boundingMapRect)
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

    private let _canDraw: ((MKMapRect, MKZoomScale) -> Bool)?
    private let _draw: (MKMapRect, MKZoomScale, CGContext) -> Void
    private var cancellables = Set<AnyCancellable>()

    // MARK: Initialization

    init(overlay: DynamicRendererMapOverlay.Overlay,
         updatePublisher: AnyPublisher<DynamicRendererMapOverlay.Update, Never>,
         canDraw: ((MKMapRect, MKZoomScale) -> Bool)?,
         draw: @escaping (MKMapRect, MKZoomScale, CGContext) -> Void) {

        self._canDraw = canDraw
        self._draw = draw
        super.init(overlay: overlay)

        updatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] in self.handle($0) }
            .store(in: &cancellables)
    }

    // MARK: Overrides

    override func canDraw(_ mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
        _canDraw?(mapRect, zoomScale) ?? super.canDraw(mapRect, zoomScale: zoomScale)
    }

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        _draw(mapRect, zoomScale, context)
    }
    
    // MARK: Helpers
    
    private func handle(_ update: DynamicRendererMapOverlay.Update) {
        let typedOverlay = overlay as? DynamicRendererMapOverlay.Overlay
        
        if let coordinate = update.coordinate {
            typedOverlay?.coordinate = coordinate
        }
        
        if let boundingMapRect = update.boundingMapRect {
            typedOverlay?.boundingMapRect = boundingMapRect
        }
        
        if let request = update.displayRequest {
            guard let mapRect = request.mapRect else {
                setNeedsDisplay()
                return
            }
            guard let zoomScale = request.zoomScale else {
                setNeedsDisplay(mapRect)
                return
            }
            setNeedsDisplay(mapRect, zoomScale: zoomScale)
        }
    }

}

#endif
