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
        .library(name: "JoinHouseUI",
                 targets: ["JoinHouseUI"]),
        .library(name: "JoinHouseLogic",
                 targets: ["JoinHouseLogic"]),
        // MARK: JoinHouse
        .library(name: "HouseFetch",
                 targets: ["HouseFetch"]),
    ],
    dependencies: [
        .package(name: "NnUIKitHelpers",
                 url: "https://github.com/nikolainobadi/NnUIKitHelpers.git",
                 branch: "main")
    ],
    targets: [
        // MARK: HouseKit
        .target(
            name: "NnHouseKit",
            dependencies: ["HouseFetch",
                           "HouseDetailUI",
                           "HouseSelectUI",
                           "HouseSearchUI",
                           "JoinHouseUI"]),
        .target(
            name: "NnHousehold",
            dependencies: []),
        // MARK: HouseListTable
        .target(
            name: "HouseListTable",
            dependencies: ["NnHousehold", "NnUIKitHelpers"]),
        .testTarget(
            name: "HouseListTableTests",
            dependencies: ["HouseListTable", "TestHelpers"]),
        // MARK: HouseDetail
        .target(
            name: "HouseDetailUI",
            dependencies: ["HouseDetailLogic", "NnUIKitHelpers", "HouseListTable"]),
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
            dependencies: ["HouseSelectLogic", "NnUIKitHelpers"]),
        .target(
            name: "HouseSelectLogic",
            dependencies: ["NnHousehold", "HouseDetailLogic"]),
        .testTarget(
            name: "HouseSelectUITests",
            dependencies: ["HouseSelectUI", "TestHelpers"]),
        .testTarget(
            name: "HouseSelectLogicTests",
            dependencies: ["HouseSelectLogic", "TestHelpers"]),
        // MARK: HouseSearch
        .target(
            name: "HouseSearchUI",
            dependencies: ["HouseSearchLogic", "NnUIKitHelpers"]),
        .target(
            name: "HouseSearchLogic",
            dependencies: ["NnHousehold"]),
        .testTarget(
            name: "HouseSearchUITests",
            dependencies: ["HouseSearchUI", "TestHelpers"]),
        .testTarget(
            name: "HouseSearchLogicTests",
            dependencies: ["HouseSearchLogic", "TestHelpers"]),
        // MARK: JoinHouse
        .target(
            name: "JoinHouseUI",
            dependencies: ["JoinHouseLogic", "NnUIKitHelpers"]),
        .target(
            name: "JoinHouseLogic",
            dependencies: ["NnHousehold"]),
        .testTarget(
            name: "JoinHouseUITests",
            dependencies: ["JoinHouseUI", "TestHelpers"]),
        .testTarget(
            name: "JoinHouseLogicTests",
            dependencies: ["JoinHouseLogic", "TestHelpers"]),
        // MARK: JoinHouse
        .target(
            name: "HouseFetch",
            dependencies: ["NnHousehold"]),
        .testTarget(
            name: "HouseFetchTests",
            dependencies: ["HouseFetch", "TestHelpers"]),
        // MARK: TestHelpers
        .target(
            name: "TestHelpers",
            dependencies: ["NnHousehold"]),
    ]
)
