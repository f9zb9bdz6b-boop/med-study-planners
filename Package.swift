// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MedStudyPlanner",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "MedStudyPlanner",
            targets: ["MedStudyPlanner"]),
    ],
    targets: [
        .target(
            name: "MedStudyPlanner",
            dependencies: [],
            path: "Sources"),
    ]
)
