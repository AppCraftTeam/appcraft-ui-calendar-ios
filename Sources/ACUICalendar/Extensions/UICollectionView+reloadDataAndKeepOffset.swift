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
}
