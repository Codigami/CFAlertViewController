// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "CFAlertViewController",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CFAlertViewController",
            targets: ["CFAlertViewController"]
        )
    ],
    targets: [
        .target(
            name: "CFAlertViewController",
            path: "CFAlertViewController"
        )
    ]
)
