//
//  ACDateHorizontalInsertRules.swift
//  
//
//  Created by Damian on 16.05.2024.
//

import UIKit

public struct ACDateHorizontalInsertRules: ACDateInsertRules {

    public init() { }
    
    public func needsInsertPastDates(_ scrollView: UIScrollView) -> Bool {
        let viewWidth = scrollView.frame.width
        let contentOffset = scrollView.contentOffset
        return contentOffset.x - viewWidth < viewWidth
    }
    
    public func needsInsertFutureDates(_ scrollView: UIScrollView) -> Bool {
        let viewWidth = scrollView.frame.width
        let contentOffset = scrollView.contentOffset
        return scrollView.contentSize.width - Double(Int(contentOffset.x)) < viewWidth * 2
    }
}
