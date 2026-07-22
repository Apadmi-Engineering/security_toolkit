// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "security_toolkit",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "security-toolkit", targets: ["security_toolkit"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "security_toolkit",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                "CInternalDarwin"
            ]
        ),
        .target(
            name: "CInternalDarwin"
        )
    ]
)
