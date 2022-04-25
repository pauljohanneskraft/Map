//
//  File.swift
//  
//
//  Created by Paul Kraft on 26.04.22.
//

#if !os(watchOS)

public struct MapInformationVisibility: OptionSet {

    // MARK: Static Properties

    public static let buildings = MapInformationVisibility(rawValue: 1 << 0)

    @available(tvOS, unavailable)
    public static let compass = MapInformationVisibility(rawValue: 1 << 1)

    @available(macOS 11, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public static let pitchControl = MapInformationVisibility(rawValue: 1 << 2)

    public static let scale = MapInformationVisibility(rawValue: 1 << 3)

    public static let traffic = MapInformationVisibility(rawValue: 1 << 4)

    public static let userLocation = MapInformationVisibility(rawValue: 1 << 5)

    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    public static let zoomControls = MapInformationVisibility(rawValue: 1 << 6)

    public static let `default` = MapInformationVisibility(arrayLiteral: .buildings)

    public static let all: MapInformationVisibility = {
        #if os(iOS)
        return MapInformationVisibility(arrayLiteral: .buildings, .compass, .scale, .traffic, .userLocation)
        #elseif os(macOS)
        if #available(macOS 11, *) {
            return MapInformationVisibility(arrayLiteral: .buildings, .compass, .scale, .traffic, .userLocation)
        } else {
            return MapInformationVisibility(arrayLiteral: .buildings, .compass, .scale, .userLocation)
        }
        #elseif os(tvOS)
        return MapInformationVisibility(arrayLiteral: .buildings, .scale, .traffic, .userLocation)
        #endif
    }()

    // MARK: Stored Properties

    public let rawValue: Int

    // MARK: Initialization

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}

#endif
