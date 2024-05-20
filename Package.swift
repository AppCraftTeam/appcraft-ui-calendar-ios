// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ACUICalendar",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "ACUICalendar",
            targets: ["ACUICalendar"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/DPLibs/DPSwift.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "ACUICalendar",
            dependencies: [
                "DPSwift"
            ],
            path: "Sources/ACUICalendar"
        ),
        .testTarget(
            name: "ACUICalendarTests",
            dependencies: ["ACUICalendar"]
        )
    ]
)
