# ACUICalendar

[![version](https://img.shields.io/badge/version-0.0.1-white.svg)](https://semver.org)
[![figma layouts used in development](https://img.shields.io/badge/figma-layouts_used_in_development-white.svg)](https://www.figma.com/file/Wy7oBUkLRVZI5Yw1N5mDiF/Calendar?node-id=0%3A1)

<img src="/Resources/demo.gif" width="300">

## Requirements
* IOS 11 or above
* Xcode 12.5 or above

## Overview
[How to use](#How_to_use)\
[Demo](#Demo)

## How to use

Create a `ACCalendarView` and display it in the parent view:
```swift
var service = ACCalendarService()

lazy var calendarView: ACCalendarView = {
   let resutl = ACCalendarView(service: self.service)

    result.didSelectDates = { [weak self] dates in
        self.service.datesSelected = dates

        // do something
    }

    return result
}()

override func viewDidLoad() {
    super.viewDidLoad()
        
    let guide = self.view.safeAreaLayoutGuide
        
    self.calendarView.removeFromSuperview()
    self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        
    self.view.addSubview(self.calendarView)
        
     NSLayoutConstraint.activate([
        self.calendarView.topAnchor.constraint(equalTo: guide.topAnchor),
        self.calendarView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
        self.calendarView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        self.calendarView.heightAnchor.constraint(equalToConstant: 352)
    ])
}
```

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
