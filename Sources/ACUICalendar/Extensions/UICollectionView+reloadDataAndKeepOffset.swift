//
//  UICollectionView+reloadDataAndKeepOffset.swift
//
//
//  Created by Damian on 16.05.2024.
//

import UIKit

extension UICollectionView {
    public func reloadDataAndKeepOffset() {
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        let afterContentSize = contentSize
        
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height)
        )
        contentOffset = newOffset
    }
    
    public func insertSectionsAndKeepOffset(_ sections: IndexSet) {
        let beforeContentSize = contentSize
        insertSections(sections)
        layoutIfNeeded()
        let afterContentSize = contentSize
        
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height)
        )
        contentOffset = newOffset
        print("insertSectionsAndKeepOffset end")
    }
    
    public func insertSectionsAndKeepOffsetWithBatchUpdates(_ sections: IndexSet) {
        let beforeContentOffset = self.contentOffset
        let beforeContentSize = self.contentSize
        
        self.performBatchUpdates({
            self.insertSections(sections)
        }, completion: { _ in
            let afterContentSize = self.contentSize
            
            let deltaX = afterContentSize.width - beforeContentSize.width
            let deltaY = afterContentSize.height - beforeContentSize.height
            
            let newOffset = CGPoint(
                x: beforeContentOffset.x + deltaX,
                y: beforeContentOffset.y + deltaY
            )
            
            UIView.performWithoutAnimation {
                self.setContentOffset(newOffset, animated: false)
            }
        })
    }
}
