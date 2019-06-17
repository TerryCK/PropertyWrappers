// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PropertyWrappers",
  products: [
    .library(
      name: "PropertyWrappers",
      targets: ["PropertyWrappers"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "PropertyWrappers",
      dependencies: []),
    .testTarget(
      name: "PropertyWrappersTests",
      dependencies: ["PropertyWrappers"]),
  ],
  swiftLanguageVersions: [.v5]
)

// For reference, the parameters Package.init takes:
//Package(
//  name: <#T##String#>,
//  platforms: <#T##[SupportedPlatform]?#>,
//  pkgConfig: <#T##String?#>,
//  providers: <#T##[SystemPackageProvider]?#>,
//  products: <#T##[Product]#>,
//  dependencies: <#T##[Package.Dependency]#>,
//  targets: <#T##[Target]#>,
//  swiftLanguageVersions: <#T##[SwiftVersion]?#>,
//  cLanguageStandard: <#T##CLanguageStandard?#>,
//  cxxLanguageStandard: <#T##CXXLanguageStandard?#>
//)
