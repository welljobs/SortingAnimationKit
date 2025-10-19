// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SortingAnimationKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SortingAnimationKit",
            targets: ["SortingAnimationKit"]
        ),
    ],
    dependencies: [

    ],
    targets: [
        .target(
            name: "SortingAnimationKit",
            dependencies: [
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "SortingAnimationKitTests",
            dependencies: ["SortingAnimationKit"],
            path: "Tests"
        ),
    ]
)
