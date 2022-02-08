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
        .library(
            name: "HouseListTable",
            targets: ["HouseListTable"]),
        // MARK: HouseDetail
        .library(name: "HouseDetailUI",
                 targets: ["HouseDetailUI"]),
        .library(name: "HouseDetailLogic",
                 targets: ["HouseDetailLogic"]),
        // MARK: HouseSelect
        .library(name: "HouseSelectUI",
                 targets: ["HouseSelectUI"]),
        .library(name: "HouseSelectLogic",
                 targets: ["HouseSelectLogic"]),
        // MARK: HouseSearch
        .library(name: "HouseSearchUI",
                 targets: ["HouseSearchUI"]),
        .library(name: "HouseSearchLogic",
                 targets: ["HouseSearchLogic"]),
        // MARK: JoinHouse
//        .library(name: "JoinHouseUI",
//                 targets: ["JoinHouseUI"]),
        .library(name: "JoinHouseLogic",
                 targets: ["JoinHouseLogic"]),
    ],
    dependencies: [
        .package(name: "NnUIViewKitPackage",
                 url: "https://github.com/nikolainobadi/NnUIViewKitPackage",
                 branch: "main")
    ],
    targets: [
        // MARK: HouseKit
        .target(
            name: "NnHouseKit",
            dependencies: ["HouseDetailUI",
                           "HouseSelectUI",
                           "HouseSearchUI"]),
        .target(
            name: "NnHousehold",
            dependencies: []),
        // MARK: HouseListTable
        .target(
            name: "HouseListTable",
            dependencies: ["NnHousehold", "NnUIViewKitPackage"]),
        .testTarget(
            name: "HouseListTableTests",
            dependencies: ["HouseListTable", "TestHelpers"]),
        // MARK: HouseDetail
        .target(
            name: "HouseDetailUI",
            dependencies: ["HouseDetailLogic", "NnUIViewKitPackage", "HouseListTable"]),
        .target(
            name: "HouseDetailLogic",
            dependencies: ["NnHousehold"]),
        .testTarget(
            name: "HouseDetailUITests",
            dependencies: ["HouseDetailUI", "TestHelpers"]),
        .testTarget(
            name: "HouseDetailLogicTests",
            dependencies: ["HouseDetailLogic", "TestHelpers"]),
        // MARK: HouseSelect
        .target(
            name: "HouseSelectUI",
            dependencies: ["HouseSelectLogic", "NnUIViewKitPackage"]),
        .target(
            name: "HouseSelectLogic",
            dependencies: ["NnHousehold"]),
        .testTarget(
            name: "HouseSelectUITests",
            dependencies: ["HouseSelectUI", "TestHelpers"]),
        .testTarget(
            name: "HouseSelectLogicTests",
            dependencies: ["HouseSelectLogic", "TestHelpers"]),
        // MARK: HouseSearch
        .target(
            name: "HouseSearchUI",
            dependencies: ["HouseSearchLogic", "NnUIViewKitPackage"]),
        .target(
            name: "HouseSearchLogic",
            dependencies: ["NnHousehold"]),
        .testTarget(
            name: "HouseSearchLogicTests",
            dependencies: ["HouseSearchLogic", "TestHelpers"]),
        .testTarget(
            name: "HouseSearchUITests",
            dependencies: ["HouseSearchUI", "TestHelpers"]),
        // MARK: JoinHouse
//        .target(
//            name: "HouseSearchUI",
//            dependencies: ["HouseSearchLogic", "NnUIViewKitPackage"]),
        .target(
            name: "JoinHouseLogic",
            dependencies: ["NnHousehold"]),
        .testTarget(
            name: "JoinHouseLogicTests",
            dependencies: ["JoinHouseLogic", "TestHelpers"]),
//        .testTarget(
//            name: "HouseSearchUITests",
//            dependencies: ["HouseSearchUI", "TestHelpers"]),
        // MARK: - TestHelpers
        .target(
            name: "TestHelpers",
            dependencies: ["NnHousehold"]),
    ]
)
