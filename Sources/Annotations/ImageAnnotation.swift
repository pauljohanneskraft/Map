//
//  ImageAnnotation.swift
//  Map
//
//  Created by Paul Kraft on 25.04.22.
//

#if canImport(WatchKit) && os(watchOS)

import MapKit
import WatchKit

public struct ImageAnnotation {

    // MARK: Stored Properties

    private let coordinate: CLLocationCoordinate2D
    private let imageName: String?
    private let image: UIImage?
    private let centerOffset: CGPoint

    // MARK: Initialization

    public init(coordinate: CLLocationCoordinate2D, image: UIImage?, centerOffset: CGPoint = .zero) {
        self.coordinate = coordinate
        self.image = image
        self.imageName = nil
        self.centerOffset = centerOffset
    }

    public init(coordinate: CLLocationCoordinate2D, imageNamed: String?, centerOffset: CGPoint = .zero) {
        self.coordinate = coordinate
        self.image = nil
        self.imageName = nil
        self.centerOffset = centerOffset
    }

}

// MARK: - MapAnnotation

extension ImageAnnotation: MapAnnotation {

    public func addAnnotation(to map: WKInterfaceMap) {
        if let name = imageName {
            map.addAnnotation(coordinate, withImageNamed: name, centerOffset: centerOffset)
        } else {
            map.addAnnotation(coordinate, with: image, centerOffset: centerOffset)
        }
    }

}

#endif
