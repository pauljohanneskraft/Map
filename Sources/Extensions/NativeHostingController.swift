//
//  NativeHostingController.swift
//  Map
//
//  Created by Paul Kraft on 25.04.22.
//

#if canImport(UIKit) && !os(watchOS)

import UIKit
import SwiftUI

typealias NativeHostingController = UIHostingController

#elseif canImport(AppKit)

import AppKit
import SwiftUI

typealias NativeHostingController = NSHostingController

#endif
