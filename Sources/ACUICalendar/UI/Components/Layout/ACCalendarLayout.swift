//
//  ACCalendarLayout.swift
//  
//
//  Created by Damian on 24.05.2024.
//

import UIKit

public protocol ACCalendarLayout: UICollectionViewFlowLayout {
    var itemHeight: CGFloat { get set }
    var isLandscapeOrientation: Bool { get set }
    
    func reloadLayout()
}
