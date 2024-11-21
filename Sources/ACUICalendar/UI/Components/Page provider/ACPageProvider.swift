//
//  ACPageProvider.swift
//
//
//  Created by Damian on 17.10.2023.
//

import UIKit
import Foundation

/// An object that defines and supplies the current page number (section index)
///
/// The ``ACPageProvider`` works on the proxy principle, that is, calls to some ``UIScrollViewDelegate``
/// methods are redirected to the provider to calculate the index of the current page.
///
/// - Note: The provider helps to solve the problem of determining the index of the current visible section
/// in the custom ``UICollectionViewFlowLayout``.
public protocol ACPageProvider {
    
    var currentPage: Int { get }

    /// Callback with page number
    var onChangePage: ((Int) -> Void)? { get set }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
}


extension ACPageProvider {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) { }
}
