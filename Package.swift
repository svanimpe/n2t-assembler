// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "hasm",
    platforms: [
        .macOS("13")
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0")
    ],
    targets: [
        .executableTarget(
            name: "hasm",
            dependencies: [
                "HackAssembler",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .target(
            name: "HackAssembler"
        ),
        .testTarget(
            name: "HackAssemblerTests",
            dependencies: [
                "HackAssembler"
            ],
            resources: [
                .process("Fixtures")
            ]
        )
    ]
)