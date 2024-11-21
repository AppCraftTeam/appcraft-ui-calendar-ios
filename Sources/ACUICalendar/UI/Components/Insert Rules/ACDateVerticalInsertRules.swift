//
//  ACDateVerticalInsertRules.swift
//
//
//  Created by Damian on 16.05.2024.
//

import UIKit

public struct ACDateVerticalInsertRules: ACDateInsertRules {
    
    public init() { }
    
    public func needsInsertPastDates(_ scrollView: UIScrollView) -> Bool {
        let contentOffset = scrollView.contentOffset
        return contentOffset.y - scrollView.frame.size.height * 1.5 <= -scrollView.contentInset.top
    }
    
    public func needsInsertFutureDates(_ scrollView: UIScrollView) -> Bool {
        let contentOffset = scrollView.contentOffset
        let itemWidth = scrollView.frame.width
        let bottomOffset = CGPoint(
            x: 0,
            y: scrollView.contentSize.height
            - scrollView.frame.size.height
            + scrollView.contentInset.top
            + scrollView.contentInset.bottom
        )
        return contentOffset.y + itemWidth * 2 >= (bottomOffset.y < 0 ? 0 : bottomOffset.y)
    }
}
