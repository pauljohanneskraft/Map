//
//  File.swift
//  
//
//  Created by Paul Kraft on 26.04.22.
//

public struct MapInformationVisibility: OptionSet {

    // MARK: Static Properties

    @available(watchOS, unavailable)
    public static let buildings = MapInformationVisibility(rawValue: 1 << 0)

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let compass = MapInformationVisibility(rawValue: 1 << 1)

    #if targetEnvironment(macCatalyst)
    @available(macCatalyst 14, *)
    public static let pitchControl = MapInformationVisibility(rawValue: 1 << 2)
    #else
    @available(iOS, unavailable)
    @available(macOS 11, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let pitchControl = MapInformationVisibility(rawValue: 1 << 2)
    #endif

    @available(watchOS, unavailable)
    public static let scale = MapInformationVisibility(rawValue: 1 << 3)

    @available(watchOS, unavailable)
    public static let traffic = MapInformationVisibility(rawValue: 1 << 4)

    @available(iOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS 6.1, *)
    public static let userHeading = MapInformationVisibility(rawValue: 1 << 5)

    @available(watchOS 6.1, *)
    public static let userLocation = MapInformationVisibility(rawValue: 1 << 6)

    #if targetEnvironment(macCatalyst)
    public static let zoomControls = MapInformationVisibility(rawValue: 1 << 7)
    #else
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static let zoomControls = MapInformationVisibility(rawValue: 1 << 7)
    #endif

    public static let `default`: MapInformationVisibility = {
        #if os(watchOS)
        return []
        #else
        return [.buildings]
        #endif
    }()

    public static let all: MapInformationVisibility = {
        var value = MapInformationVisibility()

        #if !os(watchOS)
        value.insert(.buildings)
        #endif

        #if !os(tvOS) && !os(watchOS)
        value.insert(.compass)
        #endif

        #if os(macOS) || targetEnvironment(macCatalyst)
        if #available(macCatalyst 14, macOS 11, *) {
            value.insert(.pitchControl)
        }
        #endif

        #if !os(watchOS)
        value.insert(.scale)
        value.insert(.traffic)
        #endif

        #if os(watchOS)
        if #available(watchOS 6.1, *) {
            value.insert(.userHeading)
            value.insert(.userLocation)
        }
        #else
        value.insert(.userLocation)
        #endif

        #if os(macOS) || targetEnvironment(macCatalyst)
        value.insert(.zoomControls)
        #elseif targetEnvironment(macCatalyst)
        if #available(macCatalyst 14, *) {
            value.insert(.zoomControls)
        }
        #endif

        return value
    }()

    // MARK: Stored Properties

    public let rawValue: Int

    // MARK: Initialization

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}
