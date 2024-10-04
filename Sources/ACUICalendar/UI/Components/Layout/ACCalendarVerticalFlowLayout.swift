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
}
