//
//  Map+Watch.swift
//  Map
//
//  Created by Paul Kraft on 22.04.22.
//

#if canImport(WatchKit) && os(watchOS)

import MapKit
import SwiftUI
import WatchKit

public struct Map<AnnotationItems: RandomAccessCollection> where AnnotationItems.Element: Identifiable {

    // MARK: Stored Properties

    @Binding var coordinateRegion: MKCoordinateRegion
    @Binding var mapRect: MKMapRect

    let usesRegion: Bool

    let showsUserLocation: Bool

    let usesUserTrackingMode: Bool

    @available(watchOS 6.1, *)
    @Binding var userTrackingMode: MapUserTrackingMode

    let annotationItems: AnnotationItems
    let annotationContent: (AnnotationItems.Element) -> MapAnnotation

}

// MARK: - Initialization

extension Map {

    public init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        showsUserLocation: Bool = false,
        annotationItems: AnnotationItems,
        annotationContent: @escaping (AnnotationItems.Element) -> MapAnnotation
    ) {
        self.usesRegion = true
        self._coordinateRegion = coordinateRegion
        self._mapRect = .constant(.init())
        self.showsUserLocation = showsUserLocation
        self.usesUserTrackingMode = false
        self._userTrackingMode = .constant(.none)
        self.annotationItems = annotationItems
        self.annotationContent = annotationContent
    }

    public init(
        mapRect: Binding<MKMapRect>,
        showsUserLocation: Bool = false,
        annotationItems: AnnotationItems,
        annotationContent: @escaping (AnnotationItems.Element) -> MapAnnotation
    ) {
        self.usesRegion = false
        self._coordinateRegion = .constant(.init())
        self._mapRect = mapRect
        self.showsUserLocation = showsUserLocation
        self.usesUserTrackingMode = false
        self._userTrackingMode = .constant(.none)
        self.annotationItems = annotationItems
        self.annotationContent = annotationContent
    }

    @available(watchOS 6.1, *)
    public init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        showsUserLocation: Bool = false,
        userTrackingMode: Binding<MapUserTrackingMode>?,
        annotationItems: AnnotationItems,
        annotationContent: @escaping (AnnotationItems.Element) -> MapAnnotation
    ) {
        self.usesRegion = true
        self._coordinateRegion = coordinateRegion
        self._mapRect = .constant(.init())
        self.showsUserLocation = showsUserLocation
        if let userTrackingMode = userTrackingMode {
            self.usesUserTrackingMode = true
            self._userTrackingMode = userTrackingMode
        } else {
            self.usesUserTrackingMode = false
            self._userTrackingMode = .constant(.none)
        }
        self.annotationItems = annotationItems
        self.annotationContent = annotationContent
    }

    @available(watchOS 6.1, *)
    public init(
        mapRect: Binding<MKMapRect>,
        showsUserLocation: Bool = false,
        userTrackingMode: Binding<MapUserTrackingMode>?,
        annotationItems: AnnotationItems,
        annotationContent: @escaping (AnnotationItems.Element) -> MapAnnotation
    ) {
        self.usesRegion = false
        self._coordinateRegion = .constant(.init())
        self._mapRect = mapRect
        self.showsUserLocation = showsUserLocation
        if let userTrackingMode = userTrackingMode {
            self.usesUserTrackingMode = true
            self._userTrackingMode = userTrackingMode
        } else {
            self.usesUserTrackingMode = false
            self._userTrackingMode = .constant(.none)
        }
        self.annotationItems = annotationItems
        self.annotationContent = annotationContent
    }

}

extension Map where AnnotationItems == EmptyCollection<IdentifiableObject<NSObject>> {

    public init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        showsUserLocation: Bool = false
    ) {
        self.init(
            coordinateRegion: coordinateRegion,
            showsUserLocation: showsUserLocation,
            annotationItems: .init(),
            annotationContent: { _ -> MapAnnotation in fatalError() }
        )
    }

    public init(
        mapRect: Binding<MKMapRect>,
        showsUserLocation: Bool = false
    ) {
        self.init(
            mapRect: mapRect,
            showsUserLocation: showsUserLocation,
            annotationItems: .init(),
            annotationContent: { _ -> MapAnnotation in fatalError() }
        )
    }

    @available(watchOS 6.1, *)
    public init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        showsUserLocation: Bool = false,
        userTrackingMode: Binding<MapUserTrackingMode>?
    ) {
        self.init(
            coordinateRegion: coordinateRegion,
            showsUserLocation: showsUserLocation,
            userTrackingMode: userTrackingMode,
            annotationItems: .init(),
            annotationContent: { _ -> MapAnnotation in fatalError() }
        )
    }

    @available(watchOS 6.1, *)
    public init(
        mapRect: Binding<MKMapRect>,
        showsUserLocation: Bool = false,
        userTrackingMode: Binding<MapUserTrackingMode>?
    ) {
        self.init(
            mapRect: mapRect,
            showsUserLocation: showsUserLocation,
            userTrackingMode: userTrackingMode,
            annotationItems: .init(),
            annotationContent: { _ -> MapAnnotation in fatalError() }
        )
    }

}

#endif
