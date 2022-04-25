//
//  NativeColor.swift
//  Map
//
//  Created by Paul Kraft on 25.04.22.
//

#if canImport(UIKit)

import UIKit

public typealias NativeColor = UIColor

#elseif canImport(AppKit)

import AppKit

public typealias NativeColor = NSColor

#endif
