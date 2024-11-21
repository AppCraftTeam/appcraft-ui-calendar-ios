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
    
    open var dayIsHidden: Bool {
        get { dayLabel.alpha.isZero }
        set { dayLabel.alpha = newValue ? 0 : 1 }
    }
    
    open var day: ACCalendarDayModel?
    
    open var daySelection: ACCalendarDateSelectionType = .notSelected
    
    open var theme = ACCalendarUITheme()

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
            case .notAvailableSelect:
                self.daySelectionView.backgroundColor = self.theme.dayNotSelectedBackgroundColor
            }
            
            switch self.daySelection {
            case .notSelected:
                self.dayLabel.textColor = self.theme.dayCurrentMonthNotSelectedTextColor
            case .notAvailableSelect:
                self.dayLabel.textColor = self.theme.dayCurrentMonthNotAvailableSelectTextColor
            default:
                self.dayLabel.textColor = self.theme.dayCurrentMonthSelectedTextColor
            }
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        self.dayLabel.text = nil
        self.dayLabel.textColor = .black
    }
}
