// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibOpenWeather",
    products: [
        .library(name: "LibOpenWeather", targets: ["api"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0")
    ],
    targets: [
        .target(name: "api", dependencies: ["RxSwift"]),
        .testTarget(name: "apiTests", dependencies: ["api", "RxSwift"])
    ]
)
