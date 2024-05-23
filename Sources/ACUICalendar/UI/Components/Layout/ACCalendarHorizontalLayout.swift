//
//  ACCalendarHorizontalLayout.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation
import UIKit


open class ACCalendarHorizontalLayout: ACCalendarBaseLayout {

    open override func prepare() {
        super.prepare()
        guard let collectionView else { return }
        self.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        
        let rowsCount: Double = 6
        let columnsCount: Int = 7
        let sectionWidth: CGFloat = collectionView.frame.width
        
        let sectionHeight: CGFloat = {
            if isLandscapeOrientation {
                return collectionView.frame.height
            } else {
                if self.itemHeight == .zero {
                    return collectionView.frame.height
                } else {
                    return min(collectionView.frame.height, self.itemHeight * rowsCount)
                }
            }
        }()
        
        let itemWidth = sectionWidth / CGFloat(columnsCount)
        
        var contentX = 0.0
        
        let itemHeight = sectionHeight / rowsCount

        for section in 0..<collectionView.numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            
            var currentColumn: Int = 0
            var currentRow: Int = 0
            
            for item in 0..<numberOfItems {
                let x = itemWidth * CGFloat(currentColumn) + contentX
                let y = itemHeight * CGFloat(currentRow)
                
                let frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
                let indexPath = IndexPath(item: item, section: section)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                self.itemLayoutAttributes += [attributes]
                
                if currentColumn >= columnsCount - 1 {
                    currentColumn = 0
                    currentRow += 1
                } else {
                    currentColumn += 1
                }
            }
            
            contentX += sectionWidth
        }
        self.contentSize = .init(width: contentX, height: sectionHeight)
    }
}
