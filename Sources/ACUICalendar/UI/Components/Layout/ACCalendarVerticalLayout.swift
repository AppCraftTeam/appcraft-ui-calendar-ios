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

struct LayoutCacheData: Hashable {
    var date: Date
    
    var currentColumn: Int
    var currentRow: Int
    var contentY: CGFloat
    var item: Int
    var section: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(String(date.timeIntervalSince1970) + "_\(currentColumn)" + "_\(currentRow)" + "_\(item)" + "_\(section)")
    }
}


open class ACCalendarVerticalLayout: ACCalendarBaseLayout {
    
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
    
    open var delegate: ACCalendarBaseLayoutDelegate?
    public var visibleSections: [Int] = []
    
    private var cachedAttributes: [Date: [UICollectionViewLayoutAttributes]] = [:]
    private var contentHeight: CGFloat = 0
    
    open override func prepare() {
          super.prepare()
          guard let collectionView else { return }
          self.resetLayoutAttributes()
          self.scrollDirection = .vertical
          self.calculateLayout(for: collectionView)
        
        print("zzzz \(cachedAttributes.count)")
      }
      
      private func calculateLayout(for collectionView: UICollectionView) {
          let start = Date().timeIntervalSince1970
          
          let sectionWidth: CGFloat = collectionView.frame.width
          var sectionHeight: CGFloat = {
              if isLandscapeOrientation {
                  return collectionView.frame.height
              } else {
                  return self.itemHeight == .zero ? collectionView.frame.height * 0.5 : self.itemHeight * 6
              }
          }()
          
          let collumnsCount: Int = 7
          let itemWidth = sectionWidth / CGFloat(collumnsCount)
          
          var contentY: CGFloat = 0 //contentHeight
          print("visibleSections - \(visibleSections), all - \(collectionView.numberOfSections), contentY - \(contentY)")
          for section in 0..<collectionView.numberOfSections {
              guard let sectionDate = self.delegate?.getDate(for: section) else { continue }
              
              if let cachedSectionAttributes = cachedAttributes[sectionDate] {
                  print("section \(section) already in cache")
                  //self.itemLayoutAttributes += cachedSectionAttributes
              } else {
                  //calc()
              }
              calc()
              
              func calc() {
                  let numberOfItems = collectionView.numberOfItems(inSection: section)
                  let rowsCount = numberOfItems / 7
                  
                  if self.itemHeight != .zero && !self.isLandscapeOrientation {
                      sectionHeight = Double(rowsCount) * self.itemHeight
                  }
                  let itemHeight = sectionHeight / CGFloat(rowsCount)
                  
                  var currentRow: Int = 0
                  var currentColumn: Int = 0
                  
                  if headerHeight > 0 {
                      let attr = UICollectionViewLayoutAttributes(
                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                          with: IndexPath(item: 0, section: section)
                      )
                      attr.frame = CGRect(x: 0, y: contentY, width: sectionWidth, height: headerHeight)
                      
                      self.headerLayoutAttributes.append(attr)
                      contentY += headerHeight + self.sectionInset.top
                  }
                  
                  let indexPathsForVisibleItems = self.collectionView?.indexPathsForFullyVisibleItems()
                  print("indexPathsForVisibleItems - \(indexPathsForVisibleItems)")
                  
                  for item in 0..<numberOfItems {
                      let attributes = createLayoutAttribute(
                          itemWidth: itemWidth,
                          currentColumn: currentColumn,
                          itemHeight: itemHeight,
                          currentRow: currentRow,
                          contentY: contentY,
                          item: item,
                          section: section
                      )
                      self.itemLayoutAttributes.append(attributes)
                      
                      if let cachedSectionAttributes = cachedAttributes[sectionDate] {
                        print("section \(section) already in cache - \(cachedSectionAttributes), new - \(attributes)")
                      }
                      
                      //let data = LayoutCacheData(date: sectionDate, currentColumn: currentColumn, currentRow: currentRow, contentY: contentY, item: item, section: section)
                      let data = sectionDate
                      
                      cachedAttributes[data] = []
                      cachedAttributes[data]?.append(attributes)
                      
                      if currentColumn >= collumnsCount - 1 {
                          currentColumn = 0
                          currentRow += 1
                      } else {
                          currentColumn += 1
                      }
                  }
                  
                  contentY += sectionHeight
              }
          }
          
          contentHeight = contentY
          print("\(Date().timeIntervalSince1970 - start) contentSize.... - \(sectionWidth), sectionHeight \(headerHeight), visibleSections - \(visibleSections.count), contentY - \(contentY)")
          self.headerReferenceSize = .init(width: sectionWidth, height: headerHeight)
          self.contentSize = .init(width: sectionWidth, height: contentY)
      }
      
      private func createLayoutAttribute(
          itemWidth: CGFloat,
          currentColumn: Int,
          itemHeight: CGFloat,
          currentRow: Int,
          contentY: CGFloat,
          item: Int,
          section: Int
      ) -> UICollectionViewLayoutAttributes {
          let x = itemWidth * CGFloat(currentColumn)
          let y = itemHeight * CGFloat(currentRow) + contentY
          
          let frame = CGRect(x: x, y: y, width: itemWidth, height: itemHeight)
          let indexPath = IndexPath(item: item, section: section)
          
          let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
          attributes.frame = frame
          
          return attributes
      }
}
