// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SortingAnimationKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SortingAnimationKit",
            targets: ["SortingAnimationKit"]
        ),
        .executable(
            name: "SortingAnimationDemo",
            targets: ["SortingAnimationDemo"]
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
        .executableTarget(
            name: "SortingAnimationDemo",
            dependencies: ["SortingAnimationKit"],
            path: "Examples/Demo",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
