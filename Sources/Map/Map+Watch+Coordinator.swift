//
//  Map+Watch+Coordinatorswift
//  Map
//
//  Created by Paul Kraft on 25.04.22.
//

#if canImport(WatchKit) && os(watchOS)

import MapKit
import SwiftUI
import WatchKit

extension Map: WKInterfaceObjectRepresentable {

    // MARK: Nested Types

    public class Coordinator {

        // MARK: Stored Properties

        private var view: Map?
        private var annotationContentByID = [AnnotationItems.Element.ID: MapAnnotation]()
        private var registeredAnnotationTypes = Set<ObjectIdentifier>()

        // MARK: Methods

        func update(_ mapView: WKInterfaceMap, from newView: Map, context: Context) {
            defer { view = newView }
            let animation = context.transaction.animation
            updateAnnotations(on: mapView, from: view, to: newView)
            updateRegion(on: mapView, from: view, to: newView)
            if #available(watchOS 6.1, *) {
                updateUserTracking(on: mapView, from: view, to: newView, animated: animation != nil)
            }
        }

        // MARK: Helpers

        private func updateAnnotations(on mapView: WKInterfaceMap, from previousView: Map?, to newView: Map) {
            let changes: CollectionDifference<AnnotationItems.Element>
            if let previousView = previousView {
                changes = newView.annotationItems.difference(from: previousView.annotationItems) { $0.id == $1.id }
            } else {
                changes = newView.annotationItems.difference(from: []) { $0.id == $1.id }
            }

            guard !changes.isEmpty else {
                return
            }

            mapView.removeAllAnnotations()

            for change in changes {
                switch change {
                case let .insert(_, item, _):
                    guard !annotationContentByID.keys.contains(item.id) else {
                        assertionFailure("Duplicate annotation item id \(item.id) of \(item) found.")
                        continue
                    }
                    let content = newView.annotationContent(item)
                    annotationContentByID[item.id] = content
                case let .remove(_, item, _):
                    guard annotationContentByID[item.id] != nil else {
                        assertionFailure("Missing annotation content for item \(item) encountered.")
                        continue
                    }
                    annotationContentByID.removeValue(forKey: item.id)
                }
            }

            for content in annotationContentByID.values {
                content.addAnnotation(to: mapView)
            }
        }

        private func updateRegion(on mapView: WKInterfaceMap, from previousView: Map?, to newView: Map) {
            if newView.usesUserTrackingMode {
                mapView.setRegion(newView.coordinateRegion)
            } else {
                mapView.setVisibleMapRect(newView.mapRect)
            }
        }

        @available(watchOS 6.1, *)
        private func updateUserTracking(on mapView: WKInterfaceMap, from previousView: Map?, to newView: Map, animated: Bool) {
            if previousView?.informationVisibility != newView.informationVisibility {
                mapView.setShowsUserHeading(newView.informationVisibility.contains(.userHeading))
                mapView.setShowsUserLocation(newView.informationVisibility.contains(.userLocation))
            }
            if newView.usesUserTrackingMode, previousView?.userTrackingMode != newView.userTrackingMode {
                mapView.setUserTrackingMode(newView.userTrackingMode, animated: animated)
            }
        }
    }

    // MARK: Methods

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public func makeWKInterfaceObject(context: Context) -> WKInterfaceMap {
        let mapView = WKInterfaceMap()
        updateWKInterfaceObject(mapView, context: context)
        return mapView
    }

    public func updateWKInterfaceObject(_ mapView: WKInterfaceMap, context: Context) {
        context.coordinator.update(mapView, from: self, context: context)
    }

}

#endif
