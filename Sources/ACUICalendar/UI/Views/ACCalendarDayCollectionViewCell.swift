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
    
    open lazy var daySelectionView: UIView = {
        let result = UIView()
        result.layer.cornerRadius = 20
        
        return result
    }()
    
    open var day: ACCalendarDayModel? {
        didSet { self.updateComponents() }
    }
    
    open var daySelection: ACCalendarDateSelectionType = .notSelected {
        didSet { self.updateComponents() }
    }
    
    open var theme = ACCalendarUITheme() {
        didSet { self.updateComponents() }
    }
    
    // MARK: - Methods
    open func setupComponents() {
        self.dayLabel.removeFromSuperview()
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.daySelectionView.removeFromSuperview()
        self.daySelectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.daySelectionView)
        self.contentView.addSubview(self.dayLabel)
        
        NSLayoutConstraint.activate([
            self.dayLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.dayLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.dayLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.dayLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            self.daySelectionView.widthAnchor.constraint(equalToConstant: 40),
            self.daySelectionView.heightAnchor.constraint(equalToConstant: 40),
            self.daySelectionView.centerXAnchor.constraint(equalTo: self.dayLabel.centerXAnchor),
            self.daySelectionView.centerYAnchor.constraint(equalTo: self.dayLabel.centerYAnchor)
        ])
    }
    
    open func updateComponents() {
        guard let day = self.day else { return }
        
        self.dayLabel.text = day.dayDateText
        self.dayLabel.font = self.theme.dayFont
        
        switch day.belongsToMonth {
        case .previous,
            .next:
            self.daySelectionView.isHidden = true
            self.dayLabel.textColor = self.theme.dayNotCurrentMonthTextColor
        case .current:
            self.daySelectionView.isHidden = false
            
            switch self.daySelection {
            case .notSelected:
                self.daySelectionView.backgroundColor = self.theme.dayNotSelectedBackgroundColor
            case .middleOfRange:
                self.daySelectionView.backgroundColor = self.theme.dayMiddleAtRangeBackgroundColor
            case .startOfRange:
                self.daySelectionView.backgroundColor = self.theme.dayEdgeAtRangeBackgroundColor
            case .endOfRange:
                self.daySelectionView.backgroundColor = self.theme.dayEdgeAtRangeBackgroundColor
            }
            
            switch self.daySelection {
            case .notSelected:
                self.dayLabel.textColor = self.theme.dayCurrentMonthNotSelectedTextColor
            default:
                self.dayLabel.textColor = self.theme.dayCurrentMonthSelectedTextColor
            }
        }
    }
    
}
