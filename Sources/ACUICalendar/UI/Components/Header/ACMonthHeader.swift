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
    #warning("todo remove year")
    public var format: String = "LLLL yyyy"
    public var horizonalPosition: ACMonthHeaderHorizontalPosition
    
    static var `default` = ACMonthHeader(horizonalPosition: .right)
}
