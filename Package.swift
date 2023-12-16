// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-gir",
    platforms: [.macOS(.v13)],
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
        .package(
            url: "https://github.com/drmohundro/SWXMLHash.git",
            from: "7.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftGir",
            dependencies: [
                .product(
                    name: "XMLCoder",
                    package: "xmlcoder"),
            ]),
        .executableTarget(
            name: "swift-gir",
            dependencies: [
                "SwiftGir",
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "SwiftGirTests",
            dependencies: [
                "SwiftGir",
                .product(
                    name: "SWXMLHash",
                    package: "swxmlhash"),
                .product(
                    name: "XMLCoder",
                    package: "xmlcoder"),
            ],
            resources: [
                .process("TestData/TreeComparison/collection_element.xml"),
                .process("TestData/TreeComparison/correct.xml"),
                .process("TestData/TreeComparison/less_attributes.xml"),
                .process("TestData/TreeComparison/less_elements.xml"),
                .process("TestData/TreeComparison/more_attributes.xml"),
                .process("TestData/TreeComparison/more_elements.xml"),
                .process("TestData/TreeComparison/not_collection_element.xml"),
                .process("TestData/TreeComparison/not_optional_attribute.xml"),
                .process("TestData/TreeComparison/not_optional_element.xml"),
            ]),
    ])
