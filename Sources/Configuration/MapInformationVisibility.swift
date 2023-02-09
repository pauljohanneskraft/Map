//
//  File.swift
//  
//
//  Created by Paul Kraft on 26.04.22.
//

public struct MapInformationVisibility: OptionSet {

    // MARK: Static Properties

    #if !os(watchOS)
    public static let buildings = MapInformationVisibility(rawValue: 1 << 0)
    #endif

    #if !os(tvOS) && !os(watchOS)
    public static let compass = MapInformationVisibility(rawValue: 1 << 1)
    #endif

    #if os(macOS) || targetEnvironment(macCatalyst)
    @available(macOS 11, macCatalyst 14, *)
    public static let pitchControl = MapInformationVisibility(rawValue: 1 << 2)
    #endif

    #if !os(watchOS)
    public static let scale = MapInformationVisibility(rawValue: 1 << 3)
    public static let traffic = MapInformationVisibility(rawValue: 1 << 4)
    #endif

    #if os(watchOS)
    @available(watchOS 6.1, *)
    public static let userHeading = MapInformationVisibility(rawValue: 1 << 5)
    #endif

    @available(watchOS 6.1, *)
    public static let userLocation = MapInformationVisibility(rawValue: 1 << 6)

    #if os(macOS) || targetEnvironment(macCatalyst)
    public static let zoomControls = MapInformationVisibility(rawValue: 1 << 7)
    #endif

    public static let `default`: MapInformationVisibility = {
        #if os(watchOS)
        return MapInformationVisibility(rawValue: 0)
        #else
        return MapInformationVisibility(arrayLiteral: .buildings)
        #endif
    }()

    public static let all: MapInformationVisibility = {
        #if os(macOS) || targetEnvironment(macCatalyst)
        if #available(macOS 11, macCatalyst 14, *) {
            return MapInformationVisibility(arrayLiteral: .buildings, .compass, .pitchControl, .scale, .traffic, .userLocation, .zoomControls)
        } else {
            return MapInformationVisibility(arrayLiteral: .buildings, .compass, .scale, .traffic, .userLocation, .zoomControls)
        }
        #elseif os(iOS)
        return MapInformationVisibility(arrayLiteral: .buildings, .compass, .scale, .traffic, .userLocation)
        #elseif os(tvOS)
        return MapInformationVisibility(arrayLiteral: .buildings, .scale, .traffic, .userLocation)
        #elseif os(watchOS)
        if #available(watchOS 6.1, *) {
            return MapInformationVisibility(arrayLiteral: .userHeading, .userLocation)
        } else {
            return MapInformationVisibility(rawValue: 0)
        }
        #endif
    }()

    // MARK: Stored Properties

    public let rawValue: Int

    // MARK: Initialization

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}
