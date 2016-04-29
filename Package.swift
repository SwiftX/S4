import PackageDescription

let package = Package(
    name: "S4",
    dependencies: [
        .Package(url: "https://github.com/open-swift/C7.git", majorVersion: 0, minor: 6),
    ]
)
