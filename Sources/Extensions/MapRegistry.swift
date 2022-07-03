//
//  MapRegistry.swift
//  Map
//
//  Created by Paul Kraft on 26.04.22.
//

#if !os(watchOS)

import MapKit
import SwiftUI

extension View {

    public func mapKey<Key: Hashable>(_ key: Key) -> some View {
        environment(\.mapKey, key)
    }

}

private enum MapEnvironmentKey: EnvironmentKey {

    static var defaultValue: AnyHashable? { nil }

}

extension EnvironmentValues {

    var mapKey: AnyHashable? {
        get { self[MapEnvironmentKey.self] }
        set { self[MapEnvironmentKey.self] = newValue }
    }

}

enum MapRegistry {

    private static var content = [AnyHashable: Value]()

    private struct Value {
        weak var object: MKMapView?
    }

    static func clean() {
        for (key, value) in content where value.object == nil {
            content.removeValue(forKey: key)
        }
    }

    static subscript(_ key: AnyHashable) -> MKMapView? {
        get { content[key]?.object }
        set { content[key] = newValue.map { Value(object: $0) } }
    }

}

#endif
