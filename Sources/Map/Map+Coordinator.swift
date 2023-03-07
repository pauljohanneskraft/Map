//
//  Map+Coordinator.swift
//  Map
//
//  Created by Paul Kraft on 23.04.22.
//

import MapKit
import SwiftUI

#if !os(watchOS)

extension Map {

    // MARK: Nested Types

    public class Coordinator: NSObject, MKMapViewDelegate {

        // MARK: Stored Properties

        private var view: Map?

        private var annotationContentByObject = [ObjectIdentifier: MapAnnotation]()
        private var annotationItemByObject = [ObjectIdentifier: AnnotationItems.Element]()
        private var annotationContentByID = [AnnotationItems.Element.ID: MapAnnotation]()
        private var directionsAnnotations: [MKAnnotation] = []
        
        private var overlayContentByObject = [ObjectIdentifier: MapOverlay]()
        private var overlayContentByID = [OverlayItems.Element.ID: MapOverlay]()
        private var directionsOverlay: MapOverlay? = nil
        
        private var previousBoundary: MKMapView.CameraBoundary?
        private var previousZoomRange: MKMapView.CameraZoomRange?

        private var registeredAnnotationTypes = Set<ObjectIdentifier>()
        private var regionIsChanging = false
        private var isInitialRegionChange = true

        // MARK: Initialization

        override init() {}

        deinit {
            MapRegistry.clean()
        }

        // MARK: Methods

        func update(_ mapView: MKMapView, from newView: Map, context: Context) {
            defer { view = newView }
            let animation = context.transaction.animation
            let animated = animation != nil
            updateAnnotations(on: mapView, from: view, to: newView)
            updateCamera(on: mapView, context: context, animated: animated)
            updateInformationVisibility(on: mapView, from: view, to: newView)
            updateInteractionModes(on: mapView, from: view, to: newView)
            updateOverlays(on: mapView, from: view, to: newView)
            updatePointOfInterestFilter(on: mapView, from: view, to: newView)
            updateRegion(on: mapView, from: view, to: newView, animated: animated)
            updateType(on: mapView, from: view, to: newView)
            updateUserTracking(on: mapView, from: view, to: newView, animated: animated)
            updateDirections(on: mapView, from: view, to: newView, animated: animated)
            
            if let key = context.environment.mapKey {
                MapRegistry[key] = mapView
            }
        }

        // MARK: Helpers

        private func registerAnnotationViewIfNeeded(on mapView: MKMapView, for content: MapAnnotation) {
            let contentType = type(of: content)
            let contentTypeKey = ObjectIdentifier(contentType)
            if !registeredAnnotationTypes.contains(contentTypeKey) {
                registeredAnnotationTypes.insert(contentTypeKey)
                contentType.registerView(on: mapView)
            }
        }

        private func updateAnnotations(on mapView: MKMapView, from previousView: Map?, to newView: Map) {
            let changes: CollectionDifference<AnnotationItems.Element>
            if let previousView = previousView {
                changes = newView.annotationItems.difference(from: previousView.annotationItems) { $0.id == $1.id }
            } else {
                changes = newView.annotationItems.difference(from: []) { $0.id == $1.id }
            }

            for change in changes {
                switch change {
                case let .insert(_, item, _):
                    guard !annotationContentByID.keys.contains(item.id) else {
                        assertionFailure("Duplicate annotation item id \(item.id) of \(item) found.")
                        continue
                    }
                    let content = newView.annotationContent(item)
                    let objectKey = ObjectIdentifier(content.annotation)
                    guard !annotationContentByObject.keys.contains(objectKey) else {
                        assertionFailure("Duplicate annotation for content \(content) found!")
                        continue
                    }
                    annotationContentByID[item.id] = content
                    annotationItemByObject[objectKey] = item
                    annotationContentByObject[objectKey] = content
                    registerAnnotationViewIfNeeded(on: mapView, for: content)
                    mapView.addAnnotation(content.annotation)
                case let .remove(_, item, _):
                    guard let content = annotationContentByID[item.id] else {
                        assertionFailure("Missing annotation content for item \(item) encountered.")
                        continue
                    }
                    mapView.removeAnnotation(content.annotation)
                    let objectKey = ObjectIdentifier(content.annotation)
                    annotationItemByObject.removeValue(forKey: objectKey)
                    annotationContentByObject.removeValue(forKey: objectKey)
                    annotationContentByID.removeValue(forKey: item.id)
                }
            }
        }

        private func updateCamera(on mapView: MKMapView, context: Context, animated: Bool) {
            let newBoundary = context.environment.mapBoundary
            if previousBoundary != newBoundary && mapView.cameraBoundary != newBoundary {
                mapView.setCameraBoundary(newBoundary, animated: animated)
                previousBoundary = newBoundary
            }

            let newZoomRange = context.environment.mapZoomRange
            if previousZoomRange != newZoomRange && mapView.cameraZoomRange != newZoomRange {
                mapView.setCameraZoomRange(newZoomRange, animated: animated)
                previousZoomRange = newZoomRange
            }
        }

        private func updateInformationVisibility(on mapView: MKMapView, from previousView: Map?, to newView: Map) {
            guard previousView?.informationVisibility != newView.informationVisibility else {
                return
            }

            mapView.showsBuildings = newView.informationVisibility.contains(.buildings)
            #if !os(tvOS)
            mapView.showsCompass = newView.informationVisibility.contains(.compass)
            #endif
            mapView.showsScale = newView.informationVisibility.contains(.scale)
            mapView.showsTraffic = newView.informationVisibility.contains(.traffic)
            mapView.showsUserLocation = newView.informationVisibility.contains(.userLocation)
            #if os(macOS) || targetEnvironment(macCatalyst)
            mapView.showsZoomControls = newView.informationVisibility.contains(.zoomControls)
            if #available(macOS 11, macCatalyst 14, *) {
                mapView.showsPitchControl = newView.informationVisibility.contains(.pitchControl)
            }
            #endif
        }

        private func updateInteractionModes(on mapView: MKMapView, from previousView: Map?, to newView: Map) {
            guard previousView?.interactionModes != newView.interactionModes else {
                return
            }

            mapView.isScrollEnabled = newView.interactionModes.contains(.pan)
            mapView.isZoomEnabled = newView.interactionModes.contains(.zoom)
            #if !os(tvOS)
            mapView.isRotateEnabled = newView.interactionModes.contains(.rotate)
            mapView.isPitchEnabled = newView.interactionModes.contains(.pitch)
            #endif
        }

        private func updateOverlays(on mapView: MKMapView, from previousView: Map?, to newView: Map) {
            let changes: CollectionDifference<OverlayItems.Element>
            if let previousView = previousView {
                changes = newView.overlayItems.difference(from: previousView.overlayItems) { $0.id == $1.id }
            } else {
                changes = newView.overlayItems.difference(from: []) { $0.id == $1.id }
            }

            for change in changes {
                switch change {
                case let .insert(index, item, _):
                    guard !overlayContentByID.keys.contains(item.id) else {
                        assertionFailure("Duplicate overlay item id \(item.id) of \(item) found.")
                        continue
                    }
                    let content = newView.overlayContent(item)
                    let objectKey = ObjectIdentifier(content.overlay)
                    guard !overlayContentByObject.keys.contains(objectKey) else {
                        assertionFailure("Duplicate overlay for content \(content) found!")
                        continue
                    }
                    overlayContentByObject[objectKey] = content
                    overlayContentByID[item.id] = content
                    if let level = content.level {
                        mapView.insertOverlay(content.overlay, at: index, level: level)
                    } else {
                        mapView.insertOverlay(content.overlay, at: index)
                    }
                case let .remove(_, item, _):
                    guard let content = overlayContentByID[item.id] else {
                        assertionFailure("Missing overlay content for item \(item) encountered.")
                        continue
                    }
                    overlayContentByObject.removeValue(forKey: ObjectIdentifier(content.overlay))
                    overlayContentByID.removeValue(forKey: item.id)
                    mapView.removeOverlay(content.overlay)
                }
            }
        }

        private func updatePointOfInterestFilter(on mapView: MKMapView, from previousView: Map?, to newView: Map) {
            if previousView?.pointOfInterestFilter != newView.pointOfInterestFilter {
                mapView.pointOfInterestFilter = newView.pointOfInterestFilter
            }
        }

        private func updateRegion(on mapView: MKMapView, from previousView: Map?, to newView: Map, animated: Bool) {
            guard !regionIsChanging else {
                return
            }

            if newView.usesRegion {
                let newRegion = newView.coordinateRegion
                guard !(previousView?.coordinateRegion.equals(to: newRegion) ?? false)
                        && !mapView.region.equals(to: newRegion) else {
                    return
                }
                DispatchQueue.main.async {
                    mapView.setRegion(newRegion, animated: animated)
                }
            } else {
                let newRect = newView.mapRect
                guard !(previousView?.mapRect.equals(to: newRect) ?? false)
                        && !mapView.visibleMapRect.equals(to: newRect) else {
                    return
                }
                DispatchQueue.main.async {
                    mapView.setVisibleMapRect(newRect, animated: animated)
                }
            }
        }

        private func updateType(on mapView: MKMapView, from previousView: Map?, to newView: Map) {
            if previousView?.mapType != newView.mapType {
                mapView.mapType = newView.mapType
            }
        }

        private func updateUserTracking(on mapView: MKMapView, from previousView: Map?, to newView: Map, animated: Bool) {
            if #available(macOS 11, *) {
                let newTrackingMode = newView.userTrackingMode.actualValue
                if newView.usesUserTrackingMode, mapView.userTrackingMode != newTrackingMode {
                    mapView.setUserTrackingMode(newTrackingMode, animated: animated)
                }
            }
        }
        
        private func updateDirections(on mapView: MKMapView, from previousView: Map?, to newView: Map, animated: Bool) {
            guard previousView?.directionsRequest != newView.directionsRequest else {
                return
            }
            
            let isNewDirection = newView.directionsRequest != nil && previousView?.directionsRequest != nil
            
            // Remove overlay and annotations from the mapView
            if newView.directionsRequest == nil || isNewDirection {
                if let directionsOverlay = directionsOverlay {
                    mapView.removeOverlay(directionsOverlay.overlay)
                }
                mapView.removeAnnotations(directionsAnnotations)
                directionsAnnotations = []
                directionsOverlay = nil
            }
            
            guard let directionsRequest = newView.directionsRequest,
                  let mkRequest = newView.directionsRequest?.mkRequest else {
                return
            }
            
            let directions = MKDirections(request: mkRequest)
            directions.calculate { response, error in
                guard let route = response?.routes.first else { return }
                let directionsOverlay = MapPolyline(
                    polyline: route.polyline,
                    strokeColor: directionsRequest.routeAppearance.strokeColor,
                    lineWidth: directionsRequest.routeAppearance.lineWidth
                )
                self.directionsOverlay = directionsOverlay
                self.directionsAnnotations = [
                    directionsRequest.sourceAnnotation.annotation,
                    directionsRequest.destinationAnnotation.annotation
                ]
                mapView.addAnnotations(self.directionsAnnotations)
                
                mapView.addOverlay(directionsOverlay.overlay)
                mapView.setVisibleMapRect(
                    route.polyline.boundingMapRect,
                    edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
                    animated: animated
                )
            }
        }

        // MARK: MKMapViewDelegate

        public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            guard !regionIsChanging else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.view?.coordinateRegion = mapView.region
                self?.view?.mapRect = mapView.visibleMapRect
            }
        }

        @available(macOS 11, *)
        public func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            guard let view = view, view.usesUserTrackingMode else {
                return
            }
            DispatchQueue.main.async {
                switch mode {
                case .none:
                    view.userTrackingMode = .none
                case .follow:
                    view.userTrackingMode = .follow
                case .followWithHeading:
                    #if os(macOS) || os(tvOS)
                    view.userTrackingMode = .follow
                    #else
                    view.userTrackingMode = .followWithHeading
                    #endif
                @unknown default:
                    assertionFailure("Encountered unknown user tracking mode")
                }
            }
        }

        public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            regionIsChanging = true
        }

        public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            regionIsChanging = false
            if isInitialRegionChange {
                isInitialRegionChange = false
            } else {
                mapViewDidChangeVisibleRegion(mapView)
            }
        }

        public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let directionsOverlay = directionsOverlay, ObjectIdentifier(directionsOverlay.overlay) == ObjectIdentifier(overlay) {
                return directionsOverlay.renderer(for: mapView)
            }
            guard let content = overlayContentByObject[ObjectIdentifier(overlay)] else {
                assertionFailure("Somehow an unknown overlay appeared.")
                return MKOverlayRenderer(overlay: overlay)
                
            }
            return content.renderer(for: mapView)
        }

        public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let content = annotationContentByObject[ObjectIdentifier(annotation)] {
                return content.view(for: mapView)
            } else if let clusterAnnotation = annotation as? MKClusterAnnotation {
                let members = clusterAnnotation.memberAnnotations.compactMap { annotation -> AnnotationItems.Element? in
                    guard let item = annotationItemByObject[ObjectIdentifier(annotation)] else {
                        assertionFailure("Somehow a cluster contains an unknown annotation item.")
                        return nil
                    }
                    return item
                }
                guard let content = view?.clusterAnnotation(clusterAnnotation, members) else {
                    return nil
                }
                registerAnnotationViewIfNeeded(on: mapView, for: content)
                return content.view(for: mapView)
            } else {
                return nil
            }
        }

        public func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
            MKClusterAnnotation(memberAnnotations: memberAnnotations)
        }

    }

    // MARK: Methods

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

}

#endif
