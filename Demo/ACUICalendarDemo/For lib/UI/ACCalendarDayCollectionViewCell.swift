//
//  ACCalendarDayCollectionViewCell.swift
//  ACUICalendarDemo
//
//  Created by Дмитрий Поляков on 24.08.2022.
//

import Foundation
import UIKit

open class ACCalendarDayCollectionViewCell: UICollectionViewCell {
    
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
        "ACCalendarDayCollectionViewCell"
    }
    
    open lazy var dayLabel: UILabel = {
        let result = UILabel()
        result.textAlignment = .center
        return result
    }()
    
    open var day: ACCalendarDayModel? {
        didSet { self.updateComponets() }
    }
    
    open var dayPlainTextColor: UIColor = .black {
        didSet { self.updateComponets() }
    }
    
    open var daySelectedOfEdgeTextColor: UIColor = .black {
        didSet { self.updateComponets() }
    }
    
    open var daySelectedOfMiddleTextColor: UIColor = .black {
        didSet { self.updateComponets() }
    }
    
    open var dayFont: UIFont = .systemFont(ofSize: 20, weight: .regular) {
        didSet { self.updateComponets() }
    }
    
    // MARK: - Methods
    open func setupComponents() {
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
        self.dayLabel.text = self.day?.dayDateText
        self.dayLabel.textColor = self.dayPlainTextColor
        self.dayLabel.font = self.dayFont
    }
    
}
