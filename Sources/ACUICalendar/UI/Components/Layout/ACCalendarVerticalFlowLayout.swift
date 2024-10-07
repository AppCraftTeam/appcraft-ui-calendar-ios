//
//  ACCalendarVerticalFlowLayout.swift
//
//
//  Created by Pavel Moslienko on 04.10.2024.
//

import UIKit

public class ACCalendarVerticalFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    
    private var itemHeight: CGFloat = 0
    private var headerHeight: CGFloat = 0
    private var isLandscapeOrientation: Bool = false
    
    var delegate: ACCalendarFlowLayoutDelegate?
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWidth: CGFloat = collectionView.frame.width
        let collumnsCount: Int = 7
        let itemWidth = sectionWidth / CGFloat(collumnsCount)
        
        let numberOfItems = collectionView.numberOfItems(inSection: indexPath.section)
        let rowsCount = (numberOfItems + collumnsCount - 1) / collumnsCount
        
        var sectionHeight: CGFloat {
            if isLandscapeOrientation {
                return collectionView.frame.height
            } else {
                return self.itemHeight == .zero ? collectionView.frame.height * 0.5 : self.itemHeight * 6
            }
        }
        let itemHeight = sectionHeight / CGFloat(rowsCount)
        print("itemWidth - \(itemWidth), itemHeight - \(itemHeight)")
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: headerHeight)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ACCalendarMonthSupplementaryView.identifer,
                for: indexPath
            ) as? ACCalendarMonthSupplementaryView else {
                return UICollectionReusableView()
            }
            if let theme = self.delegate?.theme {
                view.theme = theme
            }
            return view
        }
        return .init()
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        guard elementKind == UICollectionView.elementKindSectionHeader,
                let monthHeader = self.delegate?.monthHeader
        else { return  }
        
        if let view = view as? ACCalendarMonthSupplementaryView,
           let month = self.delegate?.getMonths()[safe: indexPath.section] {
                view.updateComponents(cfg: monthHeader, model: month)
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndDecelerating(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScroll(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.calendarCellDidSelected(indexPath: indexPath)

    }
}

protocol ACCalendarFlowLayoutDelegate: AnyObject {
    var monthHeader: ACMonthHeader? { get set }
    var theme: ACCalendarUITheme { get set }
    
    func getMonths() -> [ACCalendarMonthModel]
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    func calendarCellDidSelected(indexPath: IndexPath)
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
}
