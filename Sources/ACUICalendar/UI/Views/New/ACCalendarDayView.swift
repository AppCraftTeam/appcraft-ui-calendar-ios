//
//  ACCalendarDayView.swift
//
//
//  Created by Pavel Moslienko on 10.10.2024.
//

import UIKit

open class ACCalendarDayView: UIView {
    
    // MARK: - Params
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
    
    open var day: ACCalendarDayModel? {
        didSet {
            updateComponents()
        }
    }
    
    open var daySelection: ACCalendarDateSelectionType = .notSelected {
        didSet {
            updateComponents()
        }
    }
    
    open var theme = ACCalendarUITheme()
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupComponents()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupComponents()
    }
    
    // MARK: - Methods
    private func setupComponents() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.daySelectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.daySelectionView)
        self.addSubview(self.dayLabel)
        
        NSLayoutConstraint.activate([
            self.dayLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.dayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.daySelectionView.widthAnchor.constraint(equalToConstant: 40),
            self.daySelectionView.heightAnchor.constraint(equalToConstant: 40),
            self.daySelectionView.centerXAnchor.constraint(equalTo: self.dayLabel.centerXAnchor),
            self.daySelectionView.centerYAnchor.constraint(equalTo: self.dayLabel.centerYAnchor)
        ])
    }
    
    private func updateComponents() {
        guard let day = self.day else { return }
        
        self.dayLabel.text = day.dayDateText
        self.dayLabel.font = self.theme.dayFont
        
        switch day.belongsToMonth {
        case .previous, .next:
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
    
    open func reset() {
        self.dayLabel.text = nil
        self.dayLabel.textColor = .black
        self.daySelectionView.backgroundColor = .clear
    }
}
