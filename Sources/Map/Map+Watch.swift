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

@available(watchOS 6.1, *)
public struct Map<AnnotationItems: RandomAccessCollection> where AnnotationItems.Element: Identifiable {

    // MARK: Stored Properties

    @Binding var coordinateRegion: MKCoordinateRegion
    @Binding var mapRect: MKMapRect

    let usesRegion: Bool

    let informationVisibility: MapInformationVisibility
    let usesUserTrackingMode: Bool

    @Binding var userTrackingMode: WKInterfaceMap.UserTrackingMode

    let annotationItems: AnnotationItems
    let annotationContent: (AnnotationItems.Element) -> MapAnnotation

}

// MARK: - Initialization

@available(watchOS 6.1, *)
extension Map {

    public init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        informationVisibility: MapInformationVisibility = .default,
        annotationItems: AnnotationItems,
        annotationContent: @escaping (AnnotationItems.Element) -> MapAnnotation
    ) {
        self.usesRegion = true
        self._coordinateRegion = coordinateRegion
        self._mapRect = .constant(.init())
        self.informationVisibility = informationVisibility
        self.usesUserTrackingMode = false
        self._userTrackingMode = .constant(.none)
        self.annotationItems = annotationItems
        self.annotationContent = annotationContent
    }

    public init(
        mapRect: Binding<MKMapRect>,
        informationVisibility: MapInformationVisibility = .default,
        annotationItems: AnnotationItems,
        annotationContent: @escaping (AnnotationItems.Element) -> MapAnnotation
    ) {
        self.usesRegion = false
        self._coordinateRegion = .constant(.init())
        self._mapRect = mapRect
        self.informationVisibility = informationVisibility
        self.usesUserTrackingMode = false
        self._userTrackingMode = .constant(.none)
        self.annotationItems = annotationItems
        self.annotationContent = annotationContent
    }

    @available(watchOS 6.1, *)
    public init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        informationVisibility: MapInformationVisibility = .default,
        userTrackingMode: Binding<WKInterfaceMap.UserTrackingMode>?,
        annotationItems: AnnotationItems,
        annotationContent: @escaping (AnnotationItems.Element) -> MapAnnotation
    ) {
        self.usesRegion = true
        self._coordinateRegion = coordinateRegion
        self._mapRect = .constant(.init())
        self.informationVisibility = informationVisibility
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
        informationVisibility: MapInformationVisibility = .default,
        userTrackingMode: Binding<WKInterfaceMap.UserTrackingMode>?,
        annotationItems: AnnotationItems,
        annotationContent: @escaping (AnnotationItems.Element) -> MapAnnotation
    ) {
        self.usesRegion = false
        self._coordinateRegion = .constant(.init())
        self._mapRect = mapRect
        self.informationVisibility = informationVisibility
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

@available(watchOS 6.1, *)
extension Map where AnnotationItems == EmptyCollection<IdentifiableObject<NSObject>> {

    public init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        informationVisibility: MapInformationVisibility = .default
    ) {
        self.init(
            coordinateRegion: coordinateRegion,
            informationVisibility: informationVisibility,
            annotationItems: .init(),
            annotationContent: { _ -> MapAnnotation in fatalError() }
        )
    }

    public init(
        mapRect: Binding<MKMapRect>,
        informationVisibility: MapInformationVisibility = .default
    ) {
        self.init(
            mapRect: mapRect,
            informationVisibility: informationVisibility,
            annotationItems: .init(),
            annotationContent: { _ -> MapAnnotation in fatalError() }
        )
    }

    @available(watchOS 6.1, *)
    public init(
        coordinateRegion: Binding<MKCoordinateRegion>,
        informationVisibility: MapInformationVisibility = .default,
        userTrackingMode: Binding<WKInterfaceMap.UserTrackingMode>?
    ) {
        self.init(
            coordinateRegion: coordinateRegion,
            informationVisibility: informationVisibility,
            userTrackingMode: userTrackingMode,
            annotationItems: .init(),
            annotationContent: { _ -> MapAnnotation in fatalError() }
        )
    }

    @available(watchOS 6.1, *)
    public init(
        mapRect: Binding<MKMapRect>,
        informationVisibility: MapInformationVisibility = .default,
        userTrackingMode: Binding<WKInterfaceMap.UserTrackingMode>?
    ) {
        self.init(
            mapRect: mapRect,
            informationVisibility: informationVisibility,
            userTrackingMode: userTrackingMode,
            annotationItems: .init(),
            annotationContent: { _ -> MapAnnotation in fatalError() }
        )
    }

}

#endif
