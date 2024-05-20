//
//  ACCalendarUITheme.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 29.08.2022.
//

import Foundation
import UIKit

public struct ACCalendarUITheme {
    
    public init() { }
    
    public var backgroundColor: UIColor = .assetColor(name: "background")

    public var monthSelectDateTextColor: UIColor = .assetColor(name: "textPrimary")
    public var monthSelectDateFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
    public var monthSelectArrowImageTintColor: UIColor = .assetColor(name: "textPrimary")
    
    public var arrowsTintColor: UIColor = .assetColor(name: "textPrimary")
    
    public var weekDayTextColor: UIColor = .assetColor(name: "textSecondary")
    public var weekDayFont: UIFont = .systemFont(ofSize: 14)
    
    public var dayNotCurrentMonthTextColor: UIColor = .assetColor(name: "textSecondary")
    public var dayCurrentMonthSelectedTextColor: UIColor = .black
    public var dayCurrentMonthNotSelectedTextColor: UIColor = .assetColor(name: "textPrimary")
    public var dayCurrentMonthNotAvailableSelectTextColor: UIColor = .assetColor(name: "textSecondary")
    
    public var dayNotSelectedBackgroundColor: UIColor = .clear
    public var dayEdgeAtRangeBackgroundColor: UIColor = .assetColor(name: "accentPrimary")
    public var dayMiddleAtRangeBackgroundColor: UIColor = .assetColor(name: "accentSecondary")
    public var dayFont: UIFont = .systemFont(ofSize: 20, weight: .regular)
    
    public var monthPickerSelectedBackgroundColor: UIColor = .assetColor(name: "accentPrimary")
    public var monthPickerFont: UIFont = .systemFont(ofSize: 23, weight: .regular)
    public var monthPickerTextColor: UIColor = .assetColor(name: "textPrimary")
    
    public var monthHeaderTextFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)
    public var monthHeaderTextColor: UIColor = .assetColor(name: "textPrimary")

}

