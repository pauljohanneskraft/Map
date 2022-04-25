// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Map",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "Map", targets: ["Map"]),
    ],
    targets: [
        .target(name: "Map", path: "Sources"),
        .testTarget(name: "MapTests", dependencies: ["Map"], path: "Tests"),
    ]
)
