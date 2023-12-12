// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-gir",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "swift-gir",
            targets: ["swift-gir"]),
        .library(
            name: "SwiftGir",
            targets: ["SwiftGir"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            from: "1.3.0"),
        .package(
            url: "https://github.com/CoreOffice/XMLCoder.git",
            from: "0.17.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftGir"),
        .executableTarget(
            name: "swift-gir",
            dependencies: [
                "SwiftGir",
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"),
                .product(
                    name: "XMLCoder",
                    package: "xmlcoder"),
            ]),
        .testTarget(
            name: "SwiftGirTests",
            dependencies: ["SwiftGir"]),
    ])
