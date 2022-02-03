// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NnHouseKit",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "NnHouseKit",
            targets: ["NnHouseKit"]),
        .library(name: "NnHouseDetail",
                 targets: ["NnHouseDetail"]),
        .library(name: "NnHouseDetail-Logic-Presentation",
                 targets: ["NnHouseDetail-Logic-Presentation"])
    ],
    dependencies: [
        .package(name: "NnUIViewKitPackage",
                 url: "https://github.com/nikolainobadi/NnUIViewKitPackage",
                 branch: "main")
    ],
    targets: [
        .target(
            name: "NnHouseKit",
            dependencies: ["NnHouseDetail", "NnHouseSelect"]),
        .target(
            name: "NnHouseDetail",
            dependencies: ["NnHouseDetail-Logic-Presentation", "NnUIViewKitPackage"]),
        .target(
            name: "NnHouseDetail-Logic-Presentation",
            dependencies: ["NnHousehold"]),
        .target(
            name: "NnHouseSelect",
            dependencies: ["NnHouseSelect-Logic-Presentation"]),
        .target(
            name: "NnHouseSelect-Logic-Presentation",
            dependencies: ["NnHousehold"]),
        .target(
            name: "NnHousehold",
            dependencies: []),
        .testTarget(
            name: "NnHouseDetail-Logic-PresentationTests",
            dependencies: ["NnHouseDetail-Logic-Presentation"]),
    ]
)
