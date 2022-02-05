// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NnHouseKit",
    platforms: [.macOS(.v10_15), .iOS(.v14)],
    products: [
        .library(
            name: "NnHouseKit",
            targets: ["NnHouseKit"]),
        .library(name: "HouseDetailUI",
                 targets: ["HouseDetailUI"]),
        .library(name: "HouseDetailLogic",
                 targets: ["HouseDetailLogic"]),
        .library(name: "HouseSelectLogic",
                 targets: ["HouseSelectLogic"])
    ],
    dependencies: [
        .package(name: "NnUIViewKitPackage",
                 url: "https://github.com/nikolainobadi/NnUIViewKitPackage",
                 branch: "main")
    ],
    targets: [
        .target(
            name: "NnHouseKit",
            dependencies: ["HouseDetailUI"]),
        .target(
            name: "NnHousehold",
            dependencies: []),
        .target(
            name: "HouseDetailUI",
            dependencies: ["HouseDetailLogic", "NnUIViewKitPackage"]),
        .target(
            name: "HouseDetailLogic",
            dependencies: ["NnHousehold"]),
        .target(
            name: "HouseSelectLogic",
            dependencies: ["NnHousehold"]),
        .testTarget(
            name: "HouseDetailUITests",
            dependencies: ["HouseDetailUI"]),
        .testTarget(
            name: "HouseDetailLogicTests",
            dependencies: ["HouseDetailLogic"]),
        .testTarget(
            name: "HouseSelectLogicTests",
            dependencies: ["HouseSelectLogic"]),
    ]
)
