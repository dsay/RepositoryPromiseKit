// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RepositoryPromiseKit",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "RepositoryPromiseKit",
            targets: ["RepositoryPromiseKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/dsay/SwiftRepository.git", from: "1.0.0"),
        .package(name: "PromiseKit", url: "https://github.com/mxcl/PromiseKit.git", from: "6.13.3"),
        ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RepositoryPromiseKit",
            dependencies: ["SwiftRepository", "PromiseKit"]),

        .testTarget(
            name: "RepositoryPromiseKitTests",
            dependencies: ["RepositoryPromiseKit"]),
    ]
)
