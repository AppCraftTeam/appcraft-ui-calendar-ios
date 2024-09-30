//
//  ACHorizontalPageProvider.swift
//
//
//  Created by Damian on 17.10.2023.
//

import UIKit
import Foundation


/// An object that defines and provides the value of the first visible section for ``ACCalendarHorizontalLayout``.
final
public class ACHorizontalPageProvider: ACPageProvider {

    public var currentPage: Int = 0
    public var onChangePage: ((Int) -> Void)? = nil
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.getPageNumber(in: scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.getPageNumber(in: scrollView)
    }
    
    private func getPageNumber(in scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        self.currentPage = Int(page)
        self.onChangePage?(Int(page))
    }
}
