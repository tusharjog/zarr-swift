// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "ZarrSwift",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [.library(name: "ZarrSwift", targets: ["ZarrSwift"])],
    targets: [
        .target(name: "ZarrSwift", path: "Sources/ZarrSwift"),
        .executableTarget(name: "ZarrTool", dependencies: ["ZarrSwift"], path: "Sources/CLI"),
        .testTarget(name: "ZarrSwiftTests", dependencies: ["ZarrSwift"])
    ]
)
