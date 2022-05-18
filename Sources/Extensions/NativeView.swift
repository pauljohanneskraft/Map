//
//  NativeView.swift
//  Map
//
//  Created by Paul Kraft on 18.05.22.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit
import SwiftUI

typealias NativeView = UIView

#elseif canImport(AppKit)

import AppKit
import SwiftUI

typealias NativeView = NSView

#endif
