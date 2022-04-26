//
//  MapInteractionModes.swift
//  Map
//
//  Created by Paul Kraft on 24.04.22.
//

#if !os(watchOS)

public struct MapInteractionModes: OptionSet {

    // MARK: Static Properties

    public static let pan = MapInteractionModes(rawValue: 1 << 0)

    public static let zoom = MapInteractionModes(rawValue: 1 << 1)

    @available(tvOS, unavailable)
    public static let rotate = MapInteractionModes(rawValue: 1 << 2)

    @available(tvOS, unavailable)
    public static let pitch = MapInteractionModes(rawValue: 1 << 3)

    #if os(tvOS)
    public static let all = MapInteractionModes(arrayLiteral: .pan, .zoom)
    #else
    public static let all = MapInteractionModes(arrayLiteral: .pan, .zoom, .rotate, .pitch)
    #endif

    // MARK: Stored Properties

    public let rawValue: Int

    // MARK: Initialization

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}

#endif
