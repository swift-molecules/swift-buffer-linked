// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-buffer-linked",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(name: "Buffer Linked Primitive", targets: ["Buffer Linked Primitive"]),

        .library(name: "Buffer Linked", targets: ["Buffer Linked"]),
        .library(
            name: "Buffer Linked Test Support",
            targets: ["Buffer Linked Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-buffer.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-storage.git",
            branch: "main", traits: ["Generational"]),
        .package(
            url: "https://github.com/swift-atoms/swift-store.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ownership-shared.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Buffer Linked Primitive",
            dependencies: [
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Store", package: "swift-store"),
                .product(name: "Memory", package: "swift-memory"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Pool",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Ownership Shared Primitive",
                    package: "swift-ownership-shared"
                ),
                .product(name: "Storage", package: "swift-storage"),
            ]
        ),

        .target(
            name: "Buffer Linked",
            dependencies: [
                .target(name: "Buffer Linked Primitive")
            ]
        ),

        .target(
            name: "Buffer Linked Test Support",
            dependencies: [
                .target(name: "Buffer Linked")
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Buffer Linked Tests",
            dependencies: [.target(name: "Buffer Linked"), .target(name: "Buffer Linked Test Support")]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
