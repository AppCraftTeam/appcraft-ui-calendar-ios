//
//  CalendarScrollView.swift
//  ACUICalendar
//

import UIKit

open class CalendarScrollView: UIScrollView {
    
    public init() {
        super.init(frame: .zero)
        contentInsetAdjustmentBehavior = .never
    }
    
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override public var contentInsetAdjustmentBehavior: ContentInsetAdjustmentBehavior {
        didSet {
            super.contentInsetAdjustmentBehavior = .never
        }
    }
}
