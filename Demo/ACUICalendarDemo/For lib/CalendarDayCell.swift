//
//  CalendarDayCell.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation
import UIKit

open class CalendarDayCell: UICollectionViewCell {
    
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
    open class var identifer: String {
        "CalendarDayCell"
    }
    
    public lazy var dayLabel: UILabel = {
        let result = UILabel()
        result.textAlignment = .center
        return result
    }()
    
//    open override var isSelected: Bool {
//        didSet { self.updateComponets() }
//    }
//
//    var date: Date? {
//        didSet { self.updateComponets() }
//    }
//    
//    var dateSelected: Bool = false {
//        didSet { self.updateComponets() }
//    }
    
    // MARK: - Methods
    open func setupComponents() {
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
    
    open func updateComponets() {
//        self.contentView.backgroundColor = self.dateSelected ? .lightGray : .clear
    }
    
}
