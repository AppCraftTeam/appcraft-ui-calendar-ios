//
//  ACMonthHeader.swift
//  
//
//  Created by Damian on 11.09.2023.
//

import Foundation

public struct ACMonthHeader {
    /// Month format.
    ///
    /// The default format is LLLL.
    ///
    /// The LLLL format for months is the full name of the Month.
    ///
    /// > For example:
    ///  January, February, March, April, May, etc are the LLLL Format for the Month.
    public var format: String = "LLLL"
    public var style: ACMonthHeaderStyle
    public var horizonalPosition: ACMonthHeaderHorizontalPosition
    
    static var `default` = ACMonthHeader(style: .default, horizonalPosition: .right)
}
