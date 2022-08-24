//
//  ACUICalendarHorizontalLayout.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation
import UIKit

open class ACUICalendarHorizontalLayout: UICollectionViewFlowLayout {
    
    // MARK: - Props
    private var attributesCashe: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = .zero
    
    open override var collectionViewContentSize: CGSize {
        self.contentSize
    }
    
    // MARK: - Methods
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        self.attributesCashe.removeAll()
        
        let sectionWidth: CGFloat = collectionView.frame.width
        let sectionHeight: CGFloat = collectionView.frame.height
        let collumnsCount: Int = 7
        let itemWidth = sectionWidth / CGFloat(collumnsCount)
        
        var contentX: CGFloat = 0
        
        for section in 0..<collectionView.numberOfSections {
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            let rowsCount = numberOfItems / 7
            let itemHeight = sectionHeight / CGFloat(rowsCount)
            
            var currentColumn: Int = 0
            var currentRow: Int = 0

            for item in 0..<numberOfItems {
                let x = itemWidth * CGFloat(currentColumn) + contentX
                let y = itemHeight * CGFloat(currentRow)
                
                let frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
                let indexPath = IndexPath(item: item, section: section)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                self.attributesCashe += [attributes]
                
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
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        self.attributesCashe.first(where: { $0.indexPath == indexPath })
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
      
        for attributes in self.attributesCashe where attributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(attributes)
        }
        
        return visibleLayoutAttributes
    }
    
}
