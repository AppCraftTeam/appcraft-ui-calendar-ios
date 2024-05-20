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
                
        let sectionWidth: CGFloat = collectionView.frame.width
        let sectionHeight: CGFloat = collectionView.frame.height
        let collumnsCount: Int = 7
        let itemWidth = sectionWidth / CGFloat(collumnsCount)
        
        var contentX: CGFloat = 0
        
        let itemHeight = sectionHeight / CGFloat(6)

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
                
                if currentColumn >= collumnsCount - 1 {
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
