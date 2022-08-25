//
//  ACCalendarView.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 25.08.2022.
//

import Foundation
import UIKit

open class ACCalendarView: UIView {
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupComponents()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupComponents()
    }
    
    // MARK: - Props
    open lazy var weekView: ACCalendarWeekView = {
        ACCalendarWeekView()
    }()
    
    open lazy var monthCollectionView: ACCalendarMonthCollectionView = {
        let result = ACCalendarMonthCollectionView()
        
        return result
    }()
    
    // MARK: - Methods
    open func setupComponents() {
        self.weekView.removeFromSuperview()
        self.weekView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.weekView)
        
        NSLayoutConstraint.activate([
            self.weekView.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            self.weekView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.weekView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.weekView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
}


