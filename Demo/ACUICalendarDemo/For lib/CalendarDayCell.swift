//
//  CalendarDayCell.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation
import UIKit

class CalendarDayCell: UICollectionViewCell {
    
    static let identifer: String = "CalendarDayCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupComponents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupComponents()
    }
    
    lazy var dayLabel: UILabel = {
        let result = UILabel()
        result.textAlignment = .center
        return result
    }()
    
    func setupComponents() {
        self.contentView.layer.borderColor = UIColor.gray.cgColor
        self.contentView.layer.borderWidth = 0.5
        
        self.dayLabel.removeFromSuperview()
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.dayLabel)
        
        NSLayoutConstraint.activate([
            self.dayLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.dayLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.dayLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.dayLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
    
}
