//
//  ACCalendarVerticalLayout.swift
//  ACUICalendar
//
//  Created by Damian on 08.09.2023.
//

import UIKit

// TODO: Add custom section insets for layout

public protocol ACCalendarBaseLayoutDelegate: AnyObject {
    func getDate(for section: Int) -> Date?
}

open class ACCalendarVerticalLayout: ACCalendarBaseLayout {
    
    private var cachedAttributes: [Date: [UICollectionViewLayoutAttributes]] = [:]
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        return collectionView?.bounds.width ?? 0
    }
    
    open var delegate: ACCalendarBaseLayoutDelegate?
    
    open var headerHeight: Double {
        didSet {
            self.reloadLayout()
        }
    }
    
    public init(headerHeight: Double = 20) {
        self.headerHeight = headerHeight
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var visibleSections: [Int] = []
    
    open override func prepare() {
        super.prepare()
        guard let collectionView else { return }
        self.scrollDirection = .vertical
        let newVisibleSections = calculateNewVisibleSections()
        print("zzzz newVisibleSections - \(newVisibleSections), \(self.delegate)")
        resetLayoutAttributes(for: newVisibleSections)
        calculateLayout(for: collectionView, newSections: newVisibleSections)
    }
    
    private func calculateNewVisibleSections() -> Set<Date> {
        var newSections: Set<Date> = []
        let visibleSectionsRange = getVisibleSectionsRange()
        print("zzzz visibleSectionsRange - \(visibleSectionsRange)")
        for section in visibleSectionsRange.lowerBound..<visibleSectionsRange.upperBound {
            if let sectionDate = getDateForSection(section), cachedAttributes[sectionDate] == nil {
                newSections.insert(sectionDate)
            }
        }
        
        return newSections
    }
    
    private func resetLayoutAttributes(for newSections: Set<Date>) {
        for sectionDate in newSections {
            cachedAttributes[sectionDate] = []
        }
        print("zzzz 1 \(self.delegate)")
    }
    
    private func calculateLayout(for collectionView: UICollectionView, newSections: Set<Date>) {
        print("zzzz 2 \(self.delegate), newSections - \(newSections)")
        let sectionWidth = collectionView.bounds.width
        var currentY: CGFloat = contentHeight
        
        for section in 0..<collectionView.numberOfSections {
            guard let sectionDate = getDateForSection(section) else { continue }
            
            if let cachedSectionAttributes = cachedAttributes[sectionDate], !newSections.contains(sectionDate) {
                continue
            }
            
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            let itemHeight: CGFloat = calculateItemHeight(for: section)
            let rowsCount = (numberOfItems / 7) + ((numberOfItems % 7 > 0) ? 1 : 0)
            
            let collumnsCount: Int = 7
            let itemWidth = sectionWidth / CGFloat(collumnsCount)
            
            var currentRow = 0
            var currentColumn = 0
            
            if headerHeight > 0 {
                let headerAttributes = UICollectionViewLayoutAttributes(
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    with: IndexPath(item: 0, section: section)
                )
                headerAttributes.frame = CGRect(x: 0, y: currentY, width: sectionWidth, height: headerHeight)
                cachedAttributes[sectionDate]?.append(headerAttributes)
                currentY += headerHeight + sectionInset.top
            }
            
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let x = itemWidth * CGFloat(currentColumn)
                let y = itemHeight * CGFloat(currentRow) + currentY
                attributes.frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
                
                cachedAttributes[sectionDate]?.append(attributes)
                
                if currentColumn >= 6 {
                    currentColumn = 0
                    currentRow += 1
                } else {
                    currentColumn += 1
                }
            }
            
            currentY += itemHeight * CGFloat(rowsCount) + sectionInset.bottom
        }
        
        contentHeight = currentY
    }
    
    open override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAttributes: [UICollectionViewLayoutAttributes] = []
        
        for (_, attributesArray) in cachedAttributes {
            visibleAttributes.append(contentsOf: attributesArray.filter { $0.frame.intersects(rect) })
        }
        
        return visibleAttributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let sectionDate = getDateForSection(indexPath.section) {
            return cachedAttributes[sectionDate]?.first(where: { $0.indexPath == indexPath })
        }
        return nil
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let sectionDate = getDateForSection(indexPath.section) {
            return cachedAttributes[sectionDate]?.first(where: { $0.indexPath == indexPath && $0.representedElementKind == elementKind })
        }
        return nil
    }
    
    private func getDateForSection(_ section: Int) -> Date? {
        print("zzzz delegate - \(delegate), sec \(section) is \(self.delegate?.getDate(for: section))")
        return self.delegate?.getDate(for: section)
    }
    
#warning("todo")
    private func getVisibleSectionsRange() -> Range<Int> {
        return 0..<(collectionView?.numberOfSections ?? 0)
    }
    
    private func calculateItemHeight(for section: Int) -> CGFloat {
        let defaultHeight: CGFloat = itemHeight == .zero ? (collectionView?.frame.height ?? 0) * 0.5 : itemHeight
        return isLandscapeOrientation ? (collectionView?.frame.height ?? 0) : defaultHeight
    }
}
