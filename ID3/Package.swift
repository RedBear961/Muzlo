// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ID3",
    products: [
        .library(
            name: "ID3",
            targets: ["ID3"]),
    ],
	dependencies: [
		.package(path: "../Logger")
	],
    targets: [
        .target(
            name: "ID3",
            dependencies: []),
        .testTarget(
            name: "ID3Tests",
            dependencies: ["ID3"]),
    ]
)
