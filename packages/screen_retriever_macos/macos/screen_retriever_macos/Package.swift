// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "screen_retriever_macos",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "screen-retriever-macos", targets: ["screen_retriever_macos"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "screen_retriever_macos",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Classes"
        )
    ]
)
