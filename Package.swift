// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CodelyticalLivenessSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CodelyticalLivenessSDK",
            targets: ["CodelyticalLivenessSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "CodelyticalLivenessSDK",
            url: "https://github.com/CodeLytialHub/liveness-ios/releases/download/1.0.0/CodelyticalLivenessSDK.xcframework.zip",
            checksum: "64b3bae4bc4d28af67dde8118831e0a7920f9978e627b4abe54695e91a52187f"
        )
    ]
)