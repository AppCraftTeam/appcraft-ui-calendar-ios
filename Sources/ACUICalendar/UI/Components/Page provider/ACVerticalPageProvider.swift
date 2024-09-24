//
//  ACVerticalPageProvider.swift
//
//
//  Created by Damian on 17.10.2023.
//

import UIKit
import Foundation

/// An object that defines and provides the value of the first visible section for ``ACCalendarVerticalLayout``.
final
public class ACVerticalPageProvider: ACPageProvider {
    
    private var previousVisibleSection: Int?
    
    public var onChangePage: ((Int) -> Void)?
        
    private func getCurrentFirstVisibleSection(in scrollView: UIScrollView) -> Int? {
        guard let collectionView = (scrollView as? UICollectionView),
              let layout = collectionView.collectionViewLayout as? ACCalendarBaseLayout else {
            return nil
        }
        let index = layout.headerLayoutAttributes.firstIndex(where: {
            $0.frame.origin.y >= collectionView.contentOffset.y
        })
        if let index {
            let intIndex = index.toInt
            return intIndex > 0 ? intIndex - 1 : intIndex
        }
        return nil
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let firstVisibleSection = getCurrentFirstVisibleSection(in: scrollView) else { return }
        if let previousVisibleSection = self.previousVisibleSection {
            if previousVisibleSection == 0 {
                print("firstVisibleSection - zero")
                self.onChangePage?(firstVisibleSection)
            }
            if firstVisibleSection != previousVisibleSection {
                print("firstVisibleSection - \(firstVisibleSection), previousVisibleSection - \(previousVisibleSection)")
                self.previousVisibleSection = firstVisibleSection
                self.onChangePage?(firstVisibleSection)
            }
        } else {
            print("firstVisibleSection set - \(firstVisibleSection)")
            self.previousVisibleSection = firstVisibleSection
        }
    }
}
