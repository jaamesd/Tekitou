// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Tekitou",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "Tekitou",
            path: "Sources"
        )
    ]
)
