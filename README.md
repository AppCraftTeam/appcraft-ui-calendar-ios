# ACUICalendar

[![version](https://img.shields.io/badge/version-0.0.1-white.svg)](https://semver.org)

<img src="/Resources/demo.gif" width="50%" height="50%">

<!-- ![](/Resources/demo.gif) -->

## Requirements
* IOS 11 or above
* Xcode 12.5 or above

## Overview
[ACCalendarService](#ACCalendarService)\
[Views](#Strings)
[Demo](#Demo)

## ACCalendarService

## Views

## Demo
[Small project](/Demo) demonstrating the interaction of `ACUICalendar` modules in the application.

## Install
Swift Package Manager(SPM) is Apple's dependency manager tool. It is now supported in Xcode 11. So it can be used in all appleOS types of projects. It can be used alongside other tools like CocoaPods and Carthage as well.

### Install package into your packages
Add a reference and a targeting release version in the dependencies section in Package.swift file:

```swift
import PackageDescription

let package = Package(
    name: "<your_project_name>",
    products: [],
    dependencies: [
        .package(url: "https://github.com/DPLibs/appcraft-ui-calendar-ios.git", from: "<current_version>")
    ]
)
```

### Install package via Xcode

1. Go to `File` -> `Swift Packages` -> `Add Package Dependency...`
2. Then search for <https://github.com/DPLibs/appcraft-ui-calendar-ios.git>
3. And choose the version you want

## License
Distributed under the MIT License.

## Author
Email: <dmitriyap11@gmail.com>
