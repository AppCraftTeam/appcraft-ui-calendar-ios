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
        print("insertSectionsAndKeepOffset")
        let beforeContentSize = contentSize
        insertSections(sections)
        layoutIfNeeded()
        let afterContentSize = contentSize
        
        let newOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height)
        )
        contentOffset = newOffset
    }

    public func insertSectionsAndKeepOffsetWithBatchUpdates(_ sections: IndexSet) {
        DispatchQueue.main.async {
            let beforeContentSize = self.contentSize

            self.performBatchUpdates({
                self.insertSections(sections)
            }, completion: { _ in
                let afterContentSize = self.contentSize
                
                let newOffset = CGPoint(
                    x: self.contentOffset.x + (afterContentSize.width - beforeContentSize.width),
                    y: self.contentOffset.y + (afterContentSize.height - beforeContentSize.height)
                )

                UIView.performWithoutAnimation {
                    self.contentOffset = newOffset
                }
            })
        }
    }
}
