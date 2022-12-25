// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GAuthDecrypt",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GAuthDecrypt",
            targets: ["GAuthDecrypt"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.20.1"),
        .package(url: "https://github.com/norio-nomura/Base32", .upToNextMajor(from: "0.9.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GAuthDecrypt",
            dependencies: [ .product(name: "SwiftProtobuf", package: "swift-protobuf"), .product(name: "Base32", package: "Base32") ]),
        .testTarget(
            name: "GAuthDecryptTests",
            dependencies: ["GAuthDecrypt"]),
    ]
)
