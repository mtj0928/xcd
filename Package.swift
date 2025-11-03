// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "xcode-cd",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/tuist/Noora", .upToNextMajor(from: "0.36.0"))
    ],
    targets: [
        .executableTarget(
            name: "xcodecd",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Noora", package: "Noora")
            ]
        ),
    ]
)
