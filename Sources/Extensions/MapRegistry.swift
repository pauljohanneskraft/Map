//
//  MapRegistry.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

public protocol MapKey {}

extension View {

    public func mapKey(_ key: MapKey.Type) -> some View {
        environment(\.mapKey, key)
    }

}

private struct MapEnvironmentKey: EnvironmentKey {
    static var defaultValue: MapKey.Type? { nil }
}

extension EnvironmentValues {

    var mapKey: MapKey.Type? {
        get { self[MapEnvironmentKey.self] }
        set { self[MapEnvironmentKey.self] = newValue }
    }

}

enum MapRegistry {

    private static var content = [ObjectIdentifier: Value]()

    private struct Value {
        weak var object: MKMapView?
    }

    static func clean() {
        for (key, value) in content where value.object == nil {
            content.removeValue(forKey: key)
        }
    }

    static subscript(_ mapKey: MapKey.Type) -> MKMapView? {
        get { content[ObjectIdentifier(mapKey)]?.object }
        set { content[ObjectIdentifier(mapKey)] = newValue.map { Value(object: $0) } }
    }

}

#endif
